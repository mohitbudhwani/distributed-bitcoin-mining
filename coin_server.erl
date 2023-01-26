-module(coin_server).

-behaviour(gen_server).

%% API
-export([stop/0, start_link/0,coin/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {dummy}).


%% CLIENT CALL FUNCTIONS %%

start_link() ->
    gen_server:start_link({global,?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast({global, ?MODULE},stop).

coin() ->
    gen_server:call({global, ?MODULE}, {coin,[]}).

%coin(Val,IoDevice) ->
%    gen_server:call({global, ?MODULE},{coin,Val,IoDevice}).

%% CALL BACK FUNCTIONS %% 


%start(Name) ->
%    _sup:start_child(Name).

%stop(Name) ->
%    gen_server:call(Name, stop).

%start_link(Name) ->
%    gen_server:start_link({local, Name}, ?MODULE, [], []).

init(_Args) ->
    {ok, #state{dummy=1}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};

%% Handle call for pattern matching coin
handle_call({coin,[]}, _From, State) ->
    {reply, coin_logic:coin(), State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
