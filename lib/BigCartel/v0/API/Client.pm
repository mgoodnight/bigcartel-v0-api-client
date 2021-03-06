package BigCartel::v0::API::Client;

# ABSTRACT: Very simple API client module to work with the now depracated API of BigCartel

use strict;
use warnings;

use Moo;
use Furl;
use IO::Socket::SSL qw/SSL_VERIFY_PEER/;

has sub_domain => (
    is => 'rw',
    required => 1
);

has api_url => (
    is => 'ro',
    default => sub {
        return "https://api.bigcartel.com";
    }
);

has ua => (
    is      => 'ro',
    builder => sub {
        return Furl->new(
            timeout  => 300,
            ssl_opts => {
                SSL_verify_mode => SSL_VERIFY_PEER()
            }
        );
    }
);

has last_query_response => (
    is => 'rwp'
);

has last_query_error => (
    is => 'rwp'
);

sub get_store_details {
    my $self = shift;
    my $url = sprintf "%s/%s/store.json", $self->api_url, $self->sub_domain;

    return $self->_query($url);
}

sub get_store_products {
    my $self = shift;
    my $url = sprintf "%s/%s/products.json", $self->api_url, $self->sub_domain;

    return $self->_query($url);
}

sub get_store_custom_page {
    my ($self, $permalink) = @_;
    my $url = sprintf "%s/%s/page/%s.json", $self->api_url, $self->sub_domain, $permalink;

    return $self->_query($url);
}

sub _query {
    my ($self, $extractor_url) = @_;

    my $response = $self->ua->get($extractor_url);
    $self->_set_last_query_response($response);
    
    my $content_decoded = $response->decoded_content;
    $self->_set_last_query_error($content_decoded) if !$response->is_success;
    
    return $content_decoded;
}

=head1 NAME

    Big Cartel v0 API Client 

=head1 SYNOPSIS

    use BigCartel::v0::API::Client;

    my $client = BigCartel::v0::API::Client->new({
        sub_domain  => 'my_store'
    });

    my $products = $client->get_store_products;

=head1 DESCRIPTION

    Client module to interface with the deprecated v0 API from BigCartel

=head2 METHODS

=over

=item C<get_store_details>

    Request a store's details

=item C<get_store_products>

    Request a store's list of products

=item C<get_store_custom_page>

    Return a store's custom page details

=back

=cut

1;
