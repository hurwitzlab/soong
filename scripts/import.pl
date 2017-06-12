#!/usr/bin/env perl

use strict;
use feature 'say';
use Soong::DB;
use Text::RecordParser::Tab;

my $file   = shift or die 'No file';
my $schema = Soong::DB->new->schema;
my $p      = Text::RecordParser::Tab->new($file);

# normalize headers
$p->header_filter( sub { $_ = shift; s/\s+/_/g; lc $_ } );

my $i = 0;
while (my $rec = $p->fetchrow_hashref) {
    my $project_name = $rec->{'project'} or next;
    my $Project      = $schema->resultset('Project')->find_or_create({
        project_name => $project_name
    });
    say "project = ", $Project->project_name;

    my $seq_type = $rec->{'sequencing_type'} || 'Unknown';
    my $SeqType  = $schema->resultset('SeqType')->find_or_create({
        type     => $seq_type
    });
    say "seq type = ", $SeqType->type;

    my $sample_name = $rec->{'sample_set_name'}
                   || $rec->{'sample'}
                   || '';
    next unless $sample_name;
    my $Sample      = $schema->resultset('Sample')->find_or_create({
        project_id  => $Project->id,
        seq_type_id => $SeqType->id,
        sample_name => $sample_name
    });
    say "sample = ", $Sample->sample_name;

    if (my $sample_num = $rec->{'project_sample_number'}) {
        $Sample->sample_num($sample_num);
        $Sample->update;
    }

    if (my $barcode = $rec->{'sequencing_barcode'}) {
        $Sample->barcode($barcode);
        $Sample->update;
    }

    my $report = $rec->{'sequencing_report'} or next;
    my $SeqRun     = $schema->resultset('SeqRun')->find_or_create({
        sample_id => $Sample->id,
        report    => $report
    });
    say "seq run = ", $SeqRun->report;

    if (my $run_on_seq = $rec->{'run_on_Sequencer'}) {
        $SeqRun->run_on_sequencer($run_on_seq);
        $SeqRun->update;
    }
    
    my $publication = $rec->{'publication'} || 'Unknown';
    my $Publication = $schema->resultset('Publication')->find_or_create({
        publication_name => $publication
    });
    say "pub = ", $Publication->publication_name;

    my $filename = $rec->{'filename'} or next;
    my $BamFile  = $schema->resultset('BamFile')->find_or_create({
        seq_run_id     => $SeqRun->id,
        publication_id => $Publication->id,
        file_name      => $filename,
    });

    if (my $qc_cmd = $rec->{'bam_file_qc'}) {
        $BamFile->qc_command($qc_cmd);
    }

    if (my $num_total_reads = $rec->{'total_reads'}) {
        $num_total_reads =~ s/\D//g;
        if ($num_total_reads =~ /^\d+$/) {
            $BamFile->num_total_reads($num_total_reads);
        }
    }

    if (my $num_mapped_reads = $rec->{'mapped_reads'}) {
        $num_mapped_reads =~ s/\D//g;
        if ($num_mapped_reads =~ /^\d+$/) {
            $BamFile->num_mapped_reads($num_mapped_reads);
        }
    }

    if (my $culture_result = $rec->{'culture_result'}) {
        $BamFile->culture_result($culture_result);
    }

    $BamFile->update;

    printf "%3d: %s-%s (%s)\n", ++$i, 
        $Project->project_name, $Sample->sample_name, $Sample->id;
}

say "Done.";
