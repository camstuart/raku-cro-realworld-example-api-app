use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<REALWORLD_API_HOST> ||
        die("Missing REALWORLD_API_HOST in environment"),
    port => %*ENV<REALWORLD_API_PORT> ||
        die("Missing REALWORLD_API_PORT in environment"),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<REALWORLD_API_HOST>:%*ENV<REALWORLD_API_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
