use strict;
use Test::More tests => 1;

use WebService::Backlog;
use WebService::Backlog::CreateIssue;
use Encode;

use Data::Dumper;

my $backlog = WebService::Backlog->new(
    space    => 'demo',
    username => 'demo',
    password => 'demo',
);

{
    my $newissue = WebService::Backlog::CreateIssue->new(
        {
            projectId => 1,
            summary   => 'Created by WebService::Backlog!',
        }
    );
    ok($newissue);
}

