use utf8;
package Soong::Schema::Result::BamFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::BamFile

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<bam_file>

=cut

__PACKAGE__->table("bam_file");

=head1 ACCESSORS

=head2 bam_file_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 seq_run_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 publication_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 file_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 qc_command

  data_type: 'text'
  is_nullable: 1

=head2 num_total_reads

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 num_mapped_reads

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 culture_result

  data_type: 'text'
  is_nullable: 1

=head2 other_results

  data_type: 'text'
  is_nullable: 1

=head2 analyses

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "bam_file_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "seq_run_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "publication_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "file_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "qc_command",
  { data_type => "text", is_nullable => 1 },
  "num_total_reads",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "num_mapped_reads",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "culture_result",
  { data_type => "text", is_nullable => 1 },
  "other_results",
  { data_type => "text", is_nullable => 1 },
  "analyses",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</bam_file_id>

=back

=cut

__PACKAGE__->set_primary_key("bam_file_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<seq_run_id>

=over 4

=item * L</seq_run_id>

=item * L</file_name>

=back

=cut

__PACKAGE__->add_unique_constraint("seq_run_id", ["seq_run_id", "file_name"]);

=head1 RELATIONS

=head2 publication

Type: belongs_to

Related object: L<Soong::Schema::Result::Publication>

=cut

__PACKAGE__->belongs_to(
  "publication",
  "Soong::Schema::Result::Publication",
  { publication_id => "publication_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 seq_run

Type: belongs_to

Related object: L<Soong::Schema::Result::SeqRun>

=cut

__PACKAGE__->belongs_to(
  "seq_run",
  "Soong::Schema::Result::SeqRun",
  { seq_run_id => "seq_run_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-12 14:50:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nJpI1NT/MfPVmpYqmmKKTg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
