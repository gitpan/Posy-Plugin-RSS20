package Posy::Plugin::RSS20;

#
# $Id: RSS20.pm,v 1.2 2005/03/13 04:01:35 blair Exp $
#

use 5.008001;
use strict;
use warnings;

=head1 NAME

Posy::Plugin::RSS20 - Provide RSS 2.0 feeds

=head1 VERSION

This document describes Posy::Plugin::RSS20 version B<0.2>.

=cut

our $VERSION = '0.2';

=head1 SYNOPSIS

  @plugins = qw(
    Posy::Core
    ...
    Posy::Plugin::RSS20
  );
  @entry_actions = qw(header
    ...
    rss20
    render_entry
    ...
  );

=head1 DESCRIPTION

This module delivers Posy entries as a RSS 2.0 feed.

=head1 INTERFACE

=head2 rss20()

  $self->rss20($flow_state, $current_entry, $entry_state)

If the current flavour is I<xml>, this method will:

=over 4

=item * Set I<$current_entry-Z<>E<gt>{rss20_pubdate}> 

This is available for use in in flavours as I<$entry_rss20_pubdate>.

=item * Escape select HTML entities in I<$current_entry-Z<>E<gt>{body}>.

C<E<lt>>, C<E<gt>>, C<&> and C<"> are escaped.

=back

=cut
sub rss20 {
  my ($self, $flow_state, $current_entry, $entry_state) = @_;
  # TODO Make configurable
  if ($self->{path}{flavour} eq 'xml') {
    # Taken from Blosxom 2.0
    my %escape = ('<'=>'&lt;', '>'=>'&gt;', '&'=>'&amp;', '"'=>'&quot;');
    my $escape_re  = join '|' => keys %escape;
    $current_entry->{body} =~ s/($escape_re)/$escape{$1}/g;

    # And now we want the publicate date
    my $mtime = $self->{files}->{ $current_entry->{id} }->{mtime};
    $current_entry->{rss20_pubdate} = _time822($mtime);
  }
  1;
} # rss20()

#
# PRIVATE FUNCTIONS
#

sub _time822 {
  my ($mtime) = @_;
  my @time = gmtime $mtime;
  return sprintf "%3s, %02d %3s %4d %02d:%02d:%02d GMT",
    _mapDay($time[6]), $time[3], _mapMonth($time[4]), $time[5] += 1900,
    $time[2], $time[1], $time[0];
} # _time822()

sub _mapDay {
  my ($day) = @_;
  my @map = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
  return $map[$day];
} # _mapDay()

sub _mapMonth {
  my ($month) = @_;
  my @map = (
             "Jan", "Feb", "Mar", "Apr", "May", "Jun",
             "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
            );
  return $map[$month];
} # _mapMonth()

=head1 SEE ALSO

L<Perl>, L<Posy>, L<http://blogs.law.harvard.edu/tech/rss>

=head1 LIMITATIONS

=over 4

=item * Currently hardcoded to use the I<xml> flavour.

=item * Some of the optional RSS 2.0 elements are not yet supported.

=back

=head1 BUGS

Please report any bugs or feature requests to
bug-Posy-Plugin-RSS20@rt.cpan.org or through the web interface at
L<http://rt.cpan.org/>.

=head1 AUTHOR

blair christensen., E<lt>blair@devclue.comE<gt>

L<http://devclue.com/blog/code/posy/Posy::Plugin::RSS20/>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by blair christensen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 DISCLAIMER OF WARRANTY                                                                                               

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE
LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS
AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES
OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH DAMAGES.

=cut

1;

