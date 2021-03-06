%%%-------------------------------------------------------------------
%% @doc np_tcp public API
%% @end
%%%-------------------------------------------------------------------

-module(np_tcp_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    np_tcp_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
