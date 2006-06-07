package Net::Rendezvous::Publish::Backend::Avahi;

# vi: ts=4 sw=4

use strict;
use warnings;

use Net::DBus;

our $VERSION = 0.01;

sub new {
	my $class = shift;

	my $bus = Net::DBus->system();
	my $service = $bus->get_service('org.freedesktop.Avahi');
	my $server = $service->get_object('/', 'org.freedesktop.Avahi.Server');

	my $self = {group => $service->get_object($server->EntryGroupNew(),
		'org.freedesktop.Avahi.EntryGroup')};
	bless $self, $class;

	return $self;
}

sub DESTROY {
}

sub publish {
	my $self = shift;
	my %params = @_;

	$self->{group}->AddService(Net::DBus::dbus_int32(-1),
		Net::DBus::dbus_int32(-1), Net::DBus::dbus_uint32(0), $params{name},
		$params{type}, $params{domain}, $params{host},
		Net::DBus::dbus_uint16($params{port}),
		[[Net::DBus::dbus_byte($params{txt})]]);
	$self->{group}->Commit();
}

sub publish_stop {
}

1;

__END__

=head1 NAME

Net::Rendezvous::Publish::Backend::Avahi - interface to the Avahi library

=head1 DESCRIPTION

This module publishes services using the Avahi library

=head1 AUTHOR

Jack Bates <ms419@freezone.co.uk>

=head1 COPYRIGHT

Copyright 2006, Jack Bates. All rights reserved

This program is Free Software. You can redistribute it and/or modify it under
the same terms as Perl itself

=head1 SEE ALSO

Net::Rendezvous::Publish - the module this module supports

L<Avahi|http://avahi.org/>

=cut
