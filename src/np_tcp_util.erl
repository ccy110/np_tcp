-module(np_tcp_util).

-export([listen/1,controlling_process/2]).

listen(LisOpt) ->
    % LisOpt should has {port,Port} option.
    gen_tcp:listen(0,LisOpt).

controlling_process(Socket, Pid) ->
	gen_tcp:controlling_process(Socket, Pid).