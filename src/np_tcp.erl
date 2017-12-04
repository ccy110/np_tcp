-module(np_tcp).

-export([start_listener/4]).

start_listener(Ref, LisOpt, ProMod, ProModOpt) ->
    ChildSpec = [#{id => {np_tcp_listener, Ref}
                   , start => {np_tcp_listener, start_link, [Ref, LisOpt, ProMod, ProModOpt]}
                   , restart => permanent
                   , shutdown => infinity
                   , type => worker
                   , module => [np_tcp_listener]
                   }],
    supervisor:start_child(np_tcp_sup, ChildSpec).