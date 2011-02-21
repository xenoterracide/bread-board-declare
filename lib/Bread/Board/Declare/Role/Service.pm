package Bread::Board::Declare::Role::Service;
use Moose::Role;
# ABSTRACT: role for Bread::Board::Service objects

=head1 DESCRIPTION

=cut

=attr associated_attribute

=cut

has associated_attribute => (
    is       => 'ro',
    isa      => 'Class::MOP::Attribute',
    required => 1,
    weak_ref => 1,
);

around get => sub {
    my $orig = shift;
    my $self = shift;

    my $container = $self->parent_container;

    if ($self->associated_attribute->has_value($container)) {
        return $self->associated_attribute->get_value($container);
    }

    return $self->$orig(@_);
};

=method parent_container

=cut

sub parent_container {
    my $self = shift;

    my $container = $self;
    until (!defined($container)
        || ($container->isa('Bread::Board::Container')
            && $container->does('Bread::Board::Declare::Role::Object'))) {
        $container = $container->parent;
    }
    die "Couldn't find associated object!" unless defined $container;

    return $container;
}

no Moose::Role;

1;