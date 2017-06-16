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

=head2 patient_id

  data_type: 'integer'
  default_value: 1
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 sample_acc

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 sample_num

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 sample_collection_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

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
  "patient_id",
  {
    data_type => "integer",
    default_value => 1,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "sample_acc",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "sample_num",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "sample_collection_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
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

=item * L</sample_acc>

=back

=cut

__PACKAGE__->add_unique_constraint("project_id", ["project_id", "sample_acc"]);

=head1 RELATIONS

=head2 libraries

Type: has_many

Related object: L<Soong::Schema::Result::Library>

=cut

__PACKAGE__->has_many(
  "libraries",
  "Soong::Schema::Result::Library",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 project

Type: belongs_to

Related object: L<Soong::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "Soong::Schema::Result::Project",
  { project_id => "project_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 sample_attrs

Type: has_many

Related object: L<Soong::Schema::Result::SampleAttr>

=cut

__PACKAGE__->has_many(
  "sample_attrs",
  "Soong::Schema::Result::SampleAttr",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-06-15 11:29:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cRQglyBPQkYSpNWKXRw2Hw

# --------------------------------------------------
sub aliases {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    return @{ $dbh->selectcol_arrayref(
        q[
            select a.value
            from   sample_attr a, sample_attr_type t
            where  a.sample_id=?
            and    a.sample_attr_type_id=t.sample_attr_type_id
            and    t.type=?
        ],
        {},
        ($self->id, 'sample_alias')
    )};
}

# --------------------------------------------------
sub bam_file_ids {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    return @{ $dbh->selectcol_arrayref(
        q[
            select b.bam_file_id
            from   bam_file b, seq_run s, library l
            where  l.sample_id=?
            and    l.library_id=s.library_id
            and    s.seq_run_id=b.seq_run_id
        ],
        {},
        ($self->id)
    )};
}

# --------------------------------------------------
sub bam_files {
    my $self   = shift;
    my $schema = $self->result_source->storage->schema;
    return map { $schema->resultset('BamFile')->find($_) } $self->bam_file_ids;
}

# --------------------------------------------------
sub seq_run_ids {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    return @{ $dbh->selectcol_arrayref(
        q[
            select s.seq_run_id
            from   seq_run s, library l
            where  l.sample_id=?
            and    l.library_id=s.library_id
        ],
        {},
        ($self->id)
    )};
}

# --------------------------------------------------
sub seq_runs {
    my $self   = shift;
    my $schema = $self->result_source->storage->schema;
    return map { $schema->resultset('SeqRun')->find($_) } $self->seq_run_ids;
}

__PACKAGE__->meta->make_immutable;

1;
