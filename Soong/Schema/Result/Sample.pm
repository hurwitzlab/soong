use utf8;
package Soong::Schema::Result::Sample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::Sample

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample>

=cut

__PACKAGE__->table("sample");

=head1 ACCESSORS

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 seq_type_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 sample_num

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 barcode

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "project_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "seq_type_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "sample_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "sample_num",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "barcode",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<project_id>

=over 4

=item * L</project_id>

=item * L</sample_name>

=back

=cut

__PACKAGE__->add_unique_constraint("project_id", ["project_id", "sample_name"]);

=head1 RELATIONS

=head2 project

Type: belongs_to

Related object: L<Soong::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "Soong::Schema::Result::Project",
  { project_id => "project_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 seq_runs

Type: has_many

Related object: L<Soong::Schema::Result::SeqRun>

=cut

__PACKAGE__->has_many(
  "seq_runs",
  "Soong::Schema::Result::SeqRun",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 seq_type

Type: belongs_to

Related object: L<Soong::Schema::Result::SeqType>

=cut

__PACKAGE__->belongs_to(
  "seq_type",
  "Soong::Schema::Result::SeqType",
  { seq_type_id => "seq_type_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-12 14:50:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bwrQn+nB/Uo26CPEL9a59A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
