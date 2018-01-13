-module(np_tcp_acceptor).

-behaviour(gen_server).

-export([start_link/1]).

%% gen_server call_back function
-export([init/1, handle_call/3, handle_cast/2
        , handle_info/2, teminate/2, code_change/3]).

-define(SERVER, ?MODULE).
-define(TABLE,?SERVER).

start_link([Ref, NumIndex, ListenSocket, ProMod, ProModOpt, OtherOpt]) ->
    gen_server:start_link({local,list_to_atom(lists:concat([ProMod,'_','acceptor','_',NumIndex]))}
            ,?SERVER, [Ref, ListenSocket, ProMod, ProModOpt, OtherOpt], []).

init([Ref, ListenSocket, ProMod, ProModOpt, OtherOpt]) ->
    State = #{ref => Ref
        , listen_socket => ListenSocket
        , pro_mod => ProMod
        , pro_mod_opt => ProModOpt
        , other_opt => OtherOpt
    },

    gen_server:cast(self(), loop_accept),

    {ok, State}.

handle_call(_Msg, _From, _State) ->
    {reply, _Msg, _State}.
    
handle_cast(loop_accept, State) ->
    #{ref := Ref
        , listen_socket := ListenSocket
        , pro_mod_opt := ProModOpt
        , other_opt := OtherOpt
        } = State,

    case np_tcp_util:accept(ListenSocket) of
        {ok, ClientSocket} ->
            {_, ClientSup, _, _} = lists:keyfind({np_tcp_client_sup, Ref}, 1,
                                        supervisor:which_children(np_tcp_sup)),
            {ok, ConnPid} = supervisor:start_child(ClientSup, [Ref,ClientSocket,ProModOpt,OtherOpt]),
            case ConnPid of
                undefined -> error_to_do;
                ConnPid when is_pid(ConnPid) ->
                    np_tcp_util:controlling_process(ClientSocket, ConnPid)
            end;
        _ ->
            error_to_do
    end,
    gen_server:cast(self(), loop_accept),

    {noreply, State};

handle_cast(_Msg, _State) ->
    {noreply, _State}.

handle_info(_Msg, _State) ->
    {noreply, _State}.

teminate(_Reson, _State) ->
    ok.

code_change(_OldVsn, _State, _Extra) ->
    ok.