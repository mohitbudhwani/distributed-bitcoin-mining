-module(coin_client).
-author("moh").


-export([coin/0]).

% -- Removing start and stop calls since Supervisor is responsible for start
%start() ->
%    coin_server:start_link().

%stop() ->
%    coin_server:stop().

coin() ->
    coin_server:coin().

