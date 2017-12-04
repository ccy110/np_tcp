-module(np_tcp_protocol).

-callback start_link() -> {ok, pid()}.