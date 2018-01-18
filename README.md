# np_tcp
=====

(Work In Process) An simple tcp server for Erlang.

# Pre Install
-----
    You must install erlang/otp >= 17.5 and install **rebar3** build tool  

# Build
-----

    $ rebar3 compile



# How to run example
- clone np_tcp project  
`git clone https://github.com/Naupio/np_tcp.git`  
- go to np_tcp dir   
`cd np_tcp`  
- run it by rebar3  
`rebar3 shell`
- start np_tcp application and listener  
`1> np_tcp_example:run_listener().`  
- start client connect by 5 actors process  
`2> np_tcp_example:spawn_conn(5).`  

# Example code

np_tcp_example.erl

```erlang
% np_tcp_example.erl
-module(np_tcp_example).

-export([run_listener/0,spawn_conn/1]).

run_listener() ->
    application:start(np_tcp),

    Ref = np_tcp_example,
    LisOpt = [binary,{port,18080},{packet,0},{active,false},{ip,{127,0,0,1}}],
    ProMod = np_tcp_example_protocol,
    ProModOpt = [],
    OtherOpt = [],
    np_tcp:start_listener(Ref, LisOpt, ProMod, ProModOpt, OtherOpt).

spawn_conn(TestNum) when is_number(TestNum) andalso (TestNum > 0) ->
    lists:foreach( fun(MsgNum) ->
        spawn(fun() ->
            {ok,Socket} = np_tcp_util:connect({127,0,0,1},18080,[{active,true}]),
            np_tcp_util:send(Socket,<<MsgNum>>),
            error_logger:info_msg("~n send: ~w ~n",[MsgNum])
        end)
    end,
    lists:seq(1,TestNum))
    .
```

np_tcp_example_protocol

```erlang
% np_tcp_example_protocol.erl
-module(np_tcp_example_protocol).

-behaviour(gen_server).
-behaviour(np_tcp_protocol).

%% gen_server callback module
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, teminate/2, code_change/3]).

%% np_tcp_protocol module
-export([start_tcp/4]).

-define(SERVER, ?MODULE).

start_tcp(Ref, ClientSocket, ProModOpt, OtherOpt) ->
    start_link(Ref, ClientSocket, ProModOpt, OtherOpt).

start_link(Ref, ClientSocket, ProModOpt, OtherOpt) ->
    gen_server:start_link(?MODULE, [Ref, ClientSocket, ProModOpt, OtherOpt], []).

init([Ref, ClientSocket, ProModOpt, OtherOpt]) ->
    self() ! init,
    np_tcp_util:setopts(ClientSocket,[{active, once}]),
    State = #{ client_socket => ClientSocket},
    {ok, State}.

handle_call(get_client_socket, _From, #{client_socket := ClientSocket}=State) ->
    {reply,ClientSocket,State};

handle_call(_Msg, _From, _State) ->
    {reply, _Msg, _State}.


handle_cast({send,Data}, #{client_socket := ClientSocket}=State) ->
    np_tcp_util:send(ClientSocket,Data),
    {noreply, State};

handle_cast(_Msg, _State) ->
    {noreply, _State}.
    
handle_info(init, _State) ->
    {noreply, _State};

handle_info({tcp,ClientSocket,Data}, #{client_socket := ClientSocket}=State) ->
    np_tcp_util:setopts(ClientSocket,[{active, once}]),
    ReplyData = handle_tcp_data(Data),
    tcp_send(self(),ReplyData),
    {noreply, State};

handle_info(_Msg, _State) ->
    {noreply, _State}.

teminate(_Reson, _State) ->
    ok.

code_change(_OldVsn, _State, _Extra) ->
    ok.

handle_tcp_data(Data) ->
    error_logger:info_msg("~n receive: ~w ~n",[Data]),
    Data.

tcp_send(ClientPID,Data) ->
    gen_server:cast(ClientPID,{send,Data}).
```
