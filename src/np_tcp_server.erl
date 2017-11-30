-module(np_tcp_server).

-behaviour(gen_server).

-export([start/0]).

%% gen_server call_back function
-export([init/1, handle_call/3, handle_cast/2
        , handle_info/2, teminate/2, code_change/3]).

-define(SERVER, ?MODULE).

start() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok,undefined}.

handle_call(_Msg, _From, _State) ->
    {reply, _Msg, _State}.

handle_cast(_Msg, _State) ->
    {noreply, _State}.

handle_info(_Msg, _State) ->
    {noreply, _State}.

teminate(_Reson, _State) ->
    ok.

code_change(_OldVsn, _State, _Extra) ->
    ok.