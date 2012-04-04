#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'LWP::Attempt' ) || print "Bail out!
";
}

diag( "Testing LWP::Attempt $LWP::Attempt::VERSION, Perl $], $^X" );
