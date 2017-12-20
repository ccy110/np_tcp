-module(np_tcp_client_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link([Ref, ProMod]) ->
    supervisor:start_link(?MODULE, [Ref, ProMod]).

init([Ref, ProMod]) ->
    ChildSpec = #{  
                    id => {Ref,ProMod} ,
                    start => {ProMod, start_link, []},
                    restart => permanent,
                    shutdown => brutal_kill,
                    type => worker,
                    modules => [ProMod]
            },
    SupFlags = #{
        strategy => simple_one_for_one,
        intensity => 1,
        period => 5
    },
    {ok, { SupFlags, ChildSpec}}.
