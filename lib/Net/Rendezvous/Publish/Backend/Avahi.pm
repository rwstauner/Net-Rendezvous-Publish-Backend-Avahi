package Net::Rendezvous::Publish::Backend::Avahi;

# vi: ts=4 sw=4

use strict;
use warnings;

use Net::DBus;

our $VERSION = 0.02;

sub new {
	my $class = shift;

	my $bus = Net::DBus->system();
	my $service = $bus->get_service('org.freedesktop.Avahi');
	my $server = $service->get_object('/', 'org.freedesktop.Avahi.Server');

	my $self = {service => $service,
		server => $server};
	bless $self, $class;

	return $self;
}

sub DESTROY {
}

sub publish {
	my $self = shift;
	my %params = @_;

	my $group = $self->{service}->get_object($self->{server}->EntryGroupNew(),
		'org.freedesktop.Avahi.EntryGroup');
	$group->AddService(Net::DBus::dbus_int32(-1), Net::DBus::dbus_int32(-1),
		Net::DBus::dbus_uint32(0), $params{name}, $params{type},
		$params{domain}, $params{host}, Net::DBus::dbus_uint16($params{port}),

		# Add Service argument signature is aay.  Split first into key/value
		# pairs at character \x1, then map characters to bytes & add DBus type
		[map {
			[map {
				Net::DBus::dbus_byte(ord($_))
			} (split //, $_)]
		} (split /\x1/, $params{txt})]);
	$group->Commit();

	return $group;
}

sub publish_stop {
	my $self = shift;
	my ($group) = @_;

	$group->Free();
}

1;

__END__

=head1 NAME

Net::Rendezvous::Publish::Backend::Avahi - publish zeroconf data with the Avahi
library

=head1 DESCRIPTION

This module publishes zeroconf data with the Avahi library

It is a backend for the Net::Rendezvous::Publish module

=head1 AUTHOR

Jack Bates <ms419@freezone.co.uk>

=head1 COPYRIGHT

Copyright 2006, Jack Bates. All rights reserved

This program is free software. You can redistribute it and/or modify it under
the same terms as Perl itself

=head1 SEE ALSO

Net::Rendezvous::Publish - the module this module supports

L<Avahi|http://avahi.org/>

=cut
