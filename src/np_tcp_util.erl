-module(np_tcp_util).

-export([listen/1, accept/1, controlling_process/2, setopts/2]).

listen(LisOpt) ->
    % LisOpt should has {port,Port} option.
    gen_tcp:listen(0,LisOpt).

accept(ListenSocket) ->
    gen_tcp:accept(ListenSocket).

setopts(Socket, Opts) ->
	inet:setopts(Socket, Opts).

controlling_process(Socket, Pid) ->
	gen_tcp:controlling_process(Socket, Pid).