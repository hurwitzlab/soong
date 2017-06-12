use utf8;
package Soong::Schema::Result::SeqRun;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::SeqRun

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<seq_run>

=cut

__PACKAGE__->table("seq_run");

=head1 ACCESSORS

=head2 seq_run_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 run_on_sequencer

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 report

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "seq_run_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "run_on_sequencer",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "report",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_run_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_run_id");

=head1 RELATIONS

=head2 bam_files

Type: has_many

Related object: L<Soong::Schema::Result::BamFile>

=cut

__PACKAGE__->has_many(
  "bam_files",
  "Soong::Schema::Result::BamFile",
  { "foreign.seq_run_id" => "self.seq_run_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample

Type: belongs_to

Related object: L<Soong::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "Soong::Schema::Result::Sample",
  { sample_id => "sample_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-12 15:30:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dc78Vc/a9sJbn3Lgd8+qRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
