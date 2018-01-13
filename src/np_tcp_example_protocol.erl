-module(np_tcp_example_protocol).

-behaviour(np_tcp_protocol).
-behaviour(gen_server).

%% gen_server callback module
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, teminate/2, code_change/3]).

%% np_tcp_protocol module
-export([start_tcp/4]).

-define(SERVER, ?MODULE).

start_tcp([Ref, ClientSocket, ProModOpt, OtherOpt]) ->
    start_link([Ref, ClientSocket, ProModOpt, OtherOpt]).

start_link([Ref, ClientSocket, ProModOpt, OtherOpt]) ->
    gen_server:start_link({local, }
            , ?MODULE, [Ref, ClientSocket, ProModOpt, OtherOpt], []).

init([Ref, ClientSocket, ProModOpt, OtherOpt]) ->
    self() ! init,
    np_tcp_util:setopts(ClientSocket,[{active, once}])
    {ok,undefined}.

handle_call(_Msg, _From, _State) ->
    {reply, _Msg, _State}.

handle_cast(_Msg, _State) ->
    {noreply, _State}.
    
handle_info(init, _State) ->
    {noreply, _State};

handle_info(_Msg, _State) ->
    {noreply, _State}.

teminate(_Reson, _State) ->
    ok.

code_change(_OldVsn, _State, _Extra) ->
    ok.