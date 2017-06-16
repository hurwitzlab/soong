use utf8;
package Soong::Schema::Result::Patient;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::Patient

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<patient>

=cut

__PACKAGE__->table("patient");

=head1 ACCESSORS

=head2 patient_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 patient_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "patient_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "patient_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</patient_id>

=back

=cut

__PACKAGE__->set_primary_key("patient_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<patient_name>

=over 4

=item * L</patient_name>

=back

=cut

__PACKAGE__->add_unique_constraint("patient_name", ["patient_name"]);

=head1 RELATIONS

=head2 patient_attrs

Type: has_many

Related object: L<Soong::Schema::Result::PatientAttr>

=cut

__PACKAGE__->has_many(
  "patient_attrs",
  "Soong::Schema::Result::PatientAttr",
  { "foreign.patient_id" => "self.patient_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 samples

Type: has_many

Related object: L<Soong::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "Soong::Schema::Result::Sample",
  { "foreign.patient_id" => "self.patient_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-15 10:24:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UgNsjJ5Pt2uSqsz77QkDDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
