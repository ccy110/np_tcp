-module(np_tcp_protocol).

-callback start_link(Ref::any(), Socket::inet:socket(),ProModOpt::[any()],OtherOpt::[any()])
                    -> {ok, pid()}.