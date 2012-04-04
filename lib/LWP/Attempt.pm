package LWP::Attempt;

use warnings;
use strict;

=head1 NAME

LWP::Attempt - repeat GET or POST several times in case of error

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use LWP::Attempt;

    my $la = LWP::Attempt->new(
        tries => 5,     # default 3
        delay => 2,     # default 1
    );

    my $content = $la->get('http://bessarabov.ru/');

    $la->post(
        'http://bessarabov.ru/',
        params => [
            param1 => 'value1',
            param2 => 'value2',
        ],
    );

=cut

use Carp;
use LWP;
use Attempt;

=head1 METHODS

=head2 new

    my $la = LWP::Attempt->new(
        tries => 5,             # default 3
        delay => 2,             # default 1
        agent => 'MyModule'     # default is "LWP::Attempt/$VERSION "
    );

=cut

sub new {
    my ($class, %opts) = @_;

    my $self = \%opts;

    $self->{tries} = 3 unless defined($self->{tries});
    $self->{delay} = 1 unless defined($self->{delay});
    $self->{delay} = 1 unless defined($self->{delay});
    $self->{agent} = "LWP::Attempt/$VERSION " unless defined($self->{agent});

    $self->{_ua} = LWP::UserAgent->new;
    $self->{_ua}->agent($self->{agent});

    bless($self, $class);
    return $self;
}

=head2 get

    my $content = $la->get('http://bessarabov.ru/');

=cut

sub get {
    my ($self, $url) = @_;

    my $content;

    attempt {

        my $res = $self->{_ua}->get($url);

        if ($res->is_success) {
            $content = $res->content;
        } else {
            croak "Error in getting page '$url': " . $res->status_line;
        }

    } tries => $self->{tries}, delay => $self->{delay};

    return $content;
}

=head2 post

    $la->post(
        'http://bessarabov.ru/',
        params => [
            param1 => 'value1',
            param2 => 'value2',
        ],
    );

=cut

sub post {
    my ($self, $url, %opts) = @_;

    my $content;

    attempt {

        my $res = $self->{_ua}->post(
            $url,
            $opts{params},
        );

        if ($res->is_success) {
            $content = $res->content;
        } else {
            croak "Error in getting page '$url': " . $res->status_line;
        }

    } tries => $self->{tries}, delay => $self->{delay};

    return $content;
}

=head1 AUTHOR

Ivan Bessarabov, C<< <ivan at bessarabov.ru> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-lwp-attempt at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=LWP-Attempt>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SOURCE CODE

The source code for this module is hosted on GitHub http://github.com/bessarabov/LWP-Attempt

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc LWP::Attempt

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=LWP-Attempt>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/LWP-Attempt>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/LWP-Attempt>

=item * Search CPAN

L<http://search.cpan.org/dist/LWP-Attempt/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Ivan Bessarabov.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of LWP::Attempt
