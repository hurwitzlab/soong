use utf8;
package Soong::Schema::Result::PatientAttr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::PatientAttr

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<patient_attr>

=cut

__PACKAGE__->table("patient_attr");

=head1 ACCESSORS

=head2 patient_attr_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 patient_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 patient_attr_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "patient_attr_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "patient_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "patient_attr_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "value",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</patient_attr_id>

=back

=cut

__PACKAGE__->set_primary_key("patient_attr_id");

=head1 RELATIONS

=head2 patient

Type: belongs_to

Related object: L<Soong::Schema::Result::Patient>

=cut

__PACKAGE__->belongs_to(
  "patient",
  "Soong::Schema::Result::Patient",
  { patient_id => "patient_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 patient_attr_type

Type: belongs_to

Related object: L<Soong::Schema::Result::PatientAttrType>

=cut

__PACKAGE__->belongs_to(
  "patient_attr_type",
  "Soong::Schema::Result::PatientAttrType",
  { patient_attr_type_id => "patient_attr_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-16 10:31:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8Wt3VzCCywMwOzBCiHT9EQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
