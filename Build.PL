# vi: ts=4 sw=4

use strict;
use warnings;

use Module::Build;

Module::Build->new(module_name => 'Net::Rendezvous::Publish::Backend::Avahi',
	license => 'perl',
	requires => {'perl' => 5,
		'Net::Rendezvous::Publish' => 0,
		'Net::DBus' => '0.33.2'},
	create_makefile_pl => 'traditional',
	create_readme => 1,
	sign => 1)->create_build_script;
