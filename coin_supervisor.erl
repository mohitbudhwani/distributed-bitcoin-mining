-module(coin_supervisor).
-behaviour(supervisor).

%% API
-export([start_link/0,start_link_shell/0]).
-export([init/1]).

%%%% Because the supervisor was crashing %%%
start_link_shell() ->
    {ok,Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),
    Pid.
    
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    SupervisorSpecification = #{
        strategy => one_for_one, % one_for_one | one_for_all | rest_for_one | simple_one_for_one
        intensity => 10,
        period => 60},

    ChildSpecifications = [
        #{
            id => some_worker,
            start => {coin_server, start_link, []},
            restart => permanent, % permanent | transient | temporary
            shutdown => infinity,
            type => worker, % worker | supervisor
            modules => [coin_server]
        }
    ],

    {ok, {SupervisorSpecification, ChildSpecifications}}.
