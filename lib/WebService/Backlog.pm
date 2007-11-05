package WebService::Backlog;

use strict;
our $VERSION = '0.01_01';

use RPC::XML::Client;
use Carp;

use WebService::Backlog::Project;
use WebService::Backlog::Component;
use WebService::Backlog::Version;
use WebService::Backlog::User;
use WebService::Backlog::Issue;

sub new {
    my ( $class, %args ) = @_;
    croak('space must be specified')    unless ( exists $args{space} );
    croak('username must be specified') unless ( exists $args{username} );
    croak('password must be specified') unless ( exists $args{password} );

    my $client = RPC::XML::Client->new(
        'https://' . $args{space} . '.backlog.jp/XML-RPC' );
    $client->credentials( 'Backlog Basic Authenticate',
        $args{username}, $args{password} );
    $client->useragent->parse_head(0);
    $client->useragent->env_proxy;
    $client->useragent->agent("WebService::Backlog/$VERSION");
    bless { %args, client => $client }, $class;
}

sub getProjects {
    my $self = shift;
    my $req  = RPC::XML::request->new( 'backlog.getProjects', );
    my $res  = $self->{client}->send_request($req);
    croak "Error backlog.getProjects : " . $res->value->{faultString}
      if ( $res->is_fault );

    my @projects = ();
    for my $project ( @{ $res->value } ) {
        push( @projects, WebService::Backlog::Project->new($project) );
    }
    return \@projects;
}

sub getProject {
    my ( $self, $keyOrId ) = @_;
    croak "Project key or ID must be specified." unless ($keyOrId);
    my $req = RPC::XML::request->new( 'backlog.getProject', $keyOrId, );
    my $res = $self->{client}->send_request($req);
    croak "Error backlog.getProject : " . $res->value->{faultString}
      if ( $res->is_fault );
    return unless ( $res->value->{id} );
    return WebService::Backlog::Project->new( $res->value );
}

sub getComponents {
    my ( $self, $pid ) = @_;
    croak "Project ID must be specified." unless ($pid);
    my $req = RPC::XML::request->new( 'backlog.getComponents', $pid, );
    my $res = $self->{client}->send_request($req);
    croak "Error backlog.getComponents : " . $res->value->{faultString}
      if ( $res->is_fault );
    my @components = ();
    for my $component ( @{ $res->value } ) {
        push( @components, WebService::Backlog::Component->new($component) );
    }
    return \@components;
}

sub getVersions {
    my ( $self, $pid ) = @_;
    croak "Project ID must be specified." unless ($pid);
    my $req = RPC::XML::request->new( 'backlog.getVersions', $pid, );
    my $res = $self->{client}->send_request($req);
    croak "Error backlog.getVersions : " . $res->value->{faultString}
      if ( $res->is_fault );
    my @versions = ();
    for my $version ( @{ $res->value } ) {
        push( @versions, WebService::Backlog::Version->new($version) );
    }
    return \@versions;
}

sub getUsers {
    my ( $self, $pid ) = @_;
    croak "Project ID must be specified." unless ($pid);
    my $req = RPC::XML::request->new( 'backlog.getUsers', $pid, );
    my $res = $self->{client}->send_request($req);
    croak "Error backlog.getUsers : " . $res->value->{faultString}
      if ( $res->is_fault );
    my @users = ();
    for my $user ( @{ $res->value } ) {
        push( @users, WebService::Backlog::User->new($user) );
    }
    return \@users;
}

sub getIssue {
    my ( $self, $keyOrId ) = @_;
    croak "Issue key or ID must be specified." unless ($keyOrId);
    my $req = RPC::XML::request->new( 'backlog.getIssue', $keyOrId, );
    my $res = $self->{client}->send_request($req);
    croak "Error backlog.getIssue : " . $res->value->{faultString}
      if ( $res->is_fault );
    return unless ( $res->value->{id} );
    return WebService::Backlog::Issue->new( $res->value );
}

sub getComments {
    my ( $self, $id ) = @_;
    croak "Issue ID must be specified." unless ($id);
    my $req = RPC::XML::request->new( 'backlog.getComments', $id, );
    my $res = $self->{client}->send_request($req);
    croak "Error backlog.getComments : " . $res->value->{faultString}
      if ( $res->is_fault );
    my @comments = ();
    for my $comment ( @{ $res->value } ) {
        push( @comments, WebService::Backlog::Comment->new($comment) );
    }
    return \@comments;
}

sub countIssue   { croak('Not yet implemented.') }
sub findIssue    { croak('Not yet implemented.') }
sub createIssue  { croak('Not yet implemented.') }
sub updateIssue  { croak('Not yet implemented.') }
sub switchStatus { croak('Not yet implemented.') }

1;
__END__

=head1 NAME

WebService::Backlog - Perl interface to Backlog.

=head1 SYNOPSIS

  use WebService::Backlog;
  my $backlog = WebService::Backlog->new(
    space    => 'yourspaceid',
    username => 'username',
    password => 'password'
  );


=head1 DESCRIPTION

WebService::Backlog provides interface to Backlog.
Backlog is a web based project collaboration tool.

For more information on Backlog, visit the Backlog website. http://www.backlog.jp

=head1 METHODS

=head2 new

=head2 getProjects

=head2 getProject

=head2 getComponents

=head2 getVersions

=head2 getUsers

=head2 getIssue

=head2 getComments

=head2 countIssue

=head2 findIssue

=head2 createIssue

=head2 updateIssue

=head2 switchStatus


=head1 AUTHOR

Ryuzo Yamamoto E<lt>yamamoto@nulab.co.jpE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
