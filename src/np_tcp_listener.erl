-module(np_tcp_listener).

-behaviour(gen_server).

-export([start_link/1]).

%% gen_server call_back function
-export([init/1, handle_call/3, handle_cast/2
        , handle_info/2, teminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TABLE,?SERVER).

start_link([Ref, LisOpt, ProMod, ProModOpt]) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [Ref, LisOpt, ProMod, ProModOpt], []).

init([Ref, LisOpt, ProMod, ProModOpt]) ->
    self() ! init,
    State = #{ref => Ref
            , lisopt => LisOpt
            , promod => ProMod
            , promodpot => ProModOpt
            },
    {ok, State}.

handle_call(_Msg, _From, _State) ->
    {reply, _Msg, _State}.

handle_cast(_Msg, _State) ->
    {noreply, _State}.
    
handle_info(init, #{lisopt := LisOpt} = State) ->
    % proplists:get_value()
    {noreply, State};

handle_info(_Msg, _State) ->
    {noreply, _State}.

teminate(_Reson, _State) ->
    ok.

code_change(_OldVsn, _State, _Extra) ->
    ok.