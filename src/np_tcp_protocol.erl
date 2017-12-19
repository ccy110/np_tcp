-module(np_tcp_protocol).

-callback start_link(Ref::any(),
                     ProModOpt::any(),
                     OtherOpt::any()) 
                    -> {ok, pid()}.