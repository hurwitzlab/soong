use utf8;
package Soong::Schema::Result::Library;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::Library

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<library>

=cut

__PACKAGE__->table("library");

=head1 ACCESSORS

=head2 library_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

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

=head2 barcode

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "library_id",
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
  "seq_type_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "barcode",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</library_id>

=back

=cut

__PACKAGE__->set_primary_key("library_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id_2>

=over 4

=item * L</sample_id>

=item * L</barcode>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id_2", ["sample_id", "barcode"]);

=head1 RELATIONS

=head2 sample

Type: belongs_to

Related object: L<Soong::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "Soong::Schema::Result::Sample",
  { sample_id => "sample_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 seq_runs

Type: has_many

Related object: L<Soong::Schema::Result::SeqRun>

=cut

__PACKAGE__->has_many(
  "seq_runs",
  "Soong::Schema::Result::SeqRun",
  { "foreign.library_id" => "self.library_id" },
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
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-15 11:29:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/TLlZr0YBJXXgyTMzIrFag


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
