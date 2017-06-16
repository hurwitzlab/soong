#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use DateTime;
use Getopt::Long;
use Pod::Usage;
use Readonly;
use Soong::DB;
use Text::RecordParser::Tab;
use Time::ParseDate;


main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    my $file     = $args{'file'}     or pod2usage('No file');
    my $seq_type = $args{'seq_type'} || '';
    my $schema   = Soong::DB->new->schema;
    my $p        = Text::RecordParser::Tab->new($file);

    # normalize headers
    $p->header_filter( 
        sub { 
            $_ = shift; 
            s/\s+/_/g;           # spaces to underscores
            s/[(].*[)]//;        # kill stuff in parens
            s/[^a-zA-Z0-9_-]//g; # kill anything not alphanumeric
            lc $_                # lowercase only
        } 
    );

    my $i = 0;
    REC:
    while (my $rec = $p->fetchrow_hashref) {
        #
        # Project
        #
        my $project_name = valid_value($rec->{'project_name'}) or next;
        my $Project      = $schema->resultset('Project')->find_or_create({
            project_name => $project_name
        });

        #
        # Sample
        #
        my $sample_acc = valid_value($rec->{'sample_accession'}) or next;
        my $Sample     = $schema->resultset('Sample')->find_or_create({
            project_id => $Project->id,
            sample_acc => $sample_acc
        });

        printf "%3d: %s-%s (%s)\n", ++$i, 
            $Project->project_name, $Sample->sample_acc, $Sample->id;

        if (my $date = get_date($rec->{'sample_collection_date'})) {
            $Sample->sample_collection_date($date->ymd);
            $Sample->update;
        }

        my $sample_num = valid_value($rec->{'project_sample_number'}
                            || $rec->{'sample_number'}
                            || $rec->{'sample_num'}
                            || '');

        if ($sample_num =~ /^\d+$/) {
            $Sample->sample_num($sample_num);
            $Sample->update;
        }

        #
        # Sample aliases
        #
        my $AliasType = $schema->resultset('SampleAttrType')->find_or_create({
            type => 'sample_alias'
        });

        for my $fld (map { 'alias_' . $_ } (1..9)) {
            if (my $val = valid_value($rec->{ $fld })) {
                my $Alias = $schema->resultset('SampleAttr')->find_or_create({
                    sample_id           => $Sample->id,
                    sample_attr_type_id => $AliasType->id,
                    value               => $val
                });
            }
            else {
                last; # stop looking
            }
        }

        # 
        # Sample Attributes
        # 
        for my $AttrType ($schema->resultset('SampleAttrType')->all) {
            my $type = lc $AttrType->type;

            if (my $val = valid_value($rec->{ $type })) {
                my $Attr = $schema->resultset('SampleAttr')->find_or_create({
                    sample_id           => $Sample->id,
                    sample_attr_type_id => $AttrType->id,
                    value               => $val,
                });
            }
        }

        #
        # Seq Type
        #
        my $seq_type = valid_value($rec->{'sequencing_type'} || $seq_type);
        my $SeqType  = $schema->resultset('SeqType')->find_or_create({
            type     => $seq_type
        });

        #
        # Library
        #
        my $barcode = valid_value($rec->{'sequencing_barcode'} 
                        || $rec->{'barcode'});

        unless ($barcode) {
            say "No barcode, skipping to next.";
            next REC;
        }

        my $Library = $schema->resultset('Library')->find_or_create({
            sample_id   => $Sample->id,
            seq_type_id => $SeqType->id,
            barcode     => $barcode
        });
    
        #
        # SeqRun
        #
        my $report = valid_value(
            $rec->{'sequencing_report'} || $rec->{'report'} || ''
        );

        unless ($report) {
            say "No sequencing report, skipping to next";
            next REC;
        }

        my $SeqRun = $schema->resultset('SeqRun')->find_or_create(
            { library_id        => $Library->id
            , sequencing_report => $report
            },
            { key => 'library_report' }
        );

        if (my $run_on_sequencer = valid_value($rec->{'run_on_sequencer'})) {
            $SeqRun->run_on_sequencer($run_on_sequencer);
            $SeqRun->update;
        }

        #
        # BAM File
        #
        my $filename = valid_value($rec->{'filename'} || $rec->{'bamfile'});
        unless ($filename) {
            say "No BAM filename, skipping to next";
            next REC;
        }

        my $BamFile    = $schema->resultset('BamFile')->find_or_create({
            seq_run_id => $SeqRun->id,
            filename   => $filename,
        });

        if (my $qc_cmd = $rec->{'bam_file_qc'}) {
            $BamFile->qc_command($qc_cmd);
        }
    
        for my $fld (qw[total_reads mapped_reads]) {
            if (my $num = $rec->{ $fld }) {
                $num =~ s/\D//g; # kill non-digits
                if ($num =~ /^\d+$/) {
                    my $setter = "num_$fld";
                    $BamFile->$setter($num);
                }
            }
        }
    
        for my $fld (
            qw[culture_result short_culture_result other_results analyses]
        ) {
            if (my $val = valid_value($rec->{ $fld })) {
                $BamFile->$fld($val);
            }
        }

        #
        # Publication
        #
        my $publication = valid_value(
            $rec->{'include_in_paper'}    || $rec->{'publication'}
            || $rec->{'publication_name'} || ''
        );

        if ($publication) {
            my $Pub = $schema->resultset('Publication')->find_or_create({
                publication_name => $publication
            });
            $BamFile->publication_id($Pub->id);
        } 

        $BamFile->update;
    }

    say "Done.";
}


# --------------------------------------------------
sub get_date {
    my $date = valid_value(shift) or return;
    my $epoch = parsedate($date) or return;
    return DateTime->from_epoch(epoch => $epoch);
}

# --------------------------------------------------
sub valid_value {
    my $val = shift or return;
    $val =~ s/^\s*|\s*$//g;
    return 0 unless defined($val);
    return 0 if $val eq '';
    return 0 if $val eq '?';
    return 0 if lc($val) eq 'not applicable';
    return 0 if $val =~ qr{^N[/]?A$}i;
    return $val;
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'seq_type|t=s',
        'file|f=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

import.pl - import data into Soong db

=head1 SYNOPSIS

  import.pl -t 16S -f 16s.tab
  import.pl -t WGS -f wgs.tab

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Imports tab-delimited data into "soong" db.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2017 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
