use utf8;
package Soong::Schema::Result::SeqType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Soong::Schema::Result::SeqType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<seq_type>

=cut

__PACKAGE__->table("seq_type");

=head1 ACCESSORS

=head2 seq_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "seq_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_type_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type>

=over 4

=item * L</type>

=back

=cut

__PACKAGE__->add_unique_constraint("type", ["type"]);

=head1 RELATIONS

=head2 samples

Type: has_many

Related object: L<Soong::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "Soong::Schema::Result::Sample",
  { "foreign.seq_type_id" => "self.seq_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-12 14:50:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YchtSIOCR2O5oHel5NSl0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
