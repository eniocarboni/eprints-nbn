$c->{nbn}={
	posturl =>'http://nbn.depositolegale.it/api/nbn_generator.pl',
	user    =>'nbnuser',
	password=>'nbnpassword',
};

push @{$c->{fields}->{eprint}},
	{
		name => 'nbncheck',
		type => 'boolean',
		input_style => 'checkbox',
	},
	{
		name => 'nbn',
		type => 'text',
		'render_single_value' => \&EPrints::Extras::nbnRenderValue,
	},
	{
		name => 'nbnlog',
		type => 'text',
	};
sub EPrints::Extras::nbnRenderValue {
	my( $session, $field, $value ) = @_;
	my $span = $session->make_element("span", class=>"nbn");
	my $url = "http://nbn.depositolegale.it/$value;"
	my $nbnlink = $session->render_link($url,"_blank");
	$nbnlink->appendChild( $session->make_text($value));
	$span->appendChild( $nbnlink );
	return $span;
}

$c->add_trigger(EPrints::Const::EP_TRIGGER_BEFORE_COMMIT, sub {
	my ($eprint,$changed) = @_;
	my ($nbncheck,$metadataurl,$ret,$status,$repo,$host,$oai_archive_id,$nbnwebservice);
	if ($eprint->is_set("nbncheck") && 
			$eprint->get_value("nbncheck") eq 'TRUE' && 
			!$eprint->is_set("nbn") ) {
		$repo=$eprint->repository;
		$host=$repo->config('host');
		$oai_archive_id=$repo->config('oai','v2','archive_id');
		$metadataurl = "http://$host".
		"/cgi/oai2?verb=GetRecord&metadataPrefix=oai_dc&identifier=oai:".
		$oai_archive_id.":".$eprint->id;
		$nbnwebservice=$repo->plugin( "NBN::Webservice" );
		unless ($nbnwebservice) {
			print STDERR "Errore NBN::Webservice plugin non trovato!!\n";
			$eprint->set_value("nbnlog","Errore NBN::Webservice plugin non trovato!!");
			$eprint->set_value("nbncheck", "FALSE");
			return EP_TRIGGER_OK;
		}
		($ret, $status) = $nbnwebservice->mint( $eprint->get_url(), $metadataurl );
		if ($ret eq '201') {
			$eprint->set_value("nbn", $status->{'nbn'});
		} 
		else {
			$eprint->set_value("nbnlog", $status->{'status'});
			$eprint->set_value("nbncheck", "FALSE");
		}
	}
	return EP_TRIGGER_OK;
});

