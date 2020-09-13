use Cro::HTTP::Test;
use Test;
use RealWorldAPI::Routes;

test-service routes, {
    test get('/'),
            status => 200,
            body-text => '<h1> realworld-api </h1>';
}

done-testing;
