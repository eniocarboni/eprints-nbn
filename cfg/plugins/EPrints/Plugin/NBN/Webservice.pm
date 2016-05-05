package EPrints::Plugin::NBN::Webservice;

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;
use strict;

our @ISA = qw/ EPrints::Plugin /;

sub new {
	my( $class, %params ) = @_;
	my $self = $class->SUPER::new( %params );
	return $self;
}

sub mint {
	my $self=shift;
	my ($url,$metadata) = @_;
	my ($ua,$content,$nbn_config,$req,$resp,$return_code,$status);
	$ua = LWP::UserAgent->new;
	$content = '{"action":"nbn_create", "url":"'.$url.'", "metadataURL":"'.$metadata.'"}';
	$nbn_config=$self->{session}->config('nbn');
	$req = POST $nbn_config->{'posturl'},
		Content_Type => "application/json",
		Content      => $content;
	$req->authorization_basic( $nbn_config->{'user'}, $nbn_config->{'password'} );
	$resp     = $ua->request($req);
	$return_code = $resp->code;
	$status      = from_json( $resp->content );
	return $return_code, $status;
}

1;
