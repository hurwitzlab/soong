use utf8;
package Soong::Schema::Result::Publication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::Publication

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<publication>

=cut

__PACKAGE__->table("publication");

=head1 ACCESSORS

=head2 publication_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 publication_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "publication_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "publication_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</publication_id>

=back

=cut

__PACKAGE__->set_primary_key("publication_id");

=head1 RELATIONS

=head2 bam_files

Type: has_many

Related object: L<Soong::Schema::Result::BamFile>

=cut

__PACKAGE__->has_many(
  "bam_files",
  "Soong::Schema::Result::BamFile",
  { "foreign.publication_id" => "self.publication_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-12 14:50:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iDXeiYdJj+DugIuGc8hP3A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
