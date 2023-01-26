-module(main).
-import(string,[substr/3,concat/2]). 
-export([start/0,get_random_string/2]).

%-define (UFname,"mbudhwani").

%gen_random_str(Bytes) ->
%    io:fwrite(base64:encode(crypto:strong_rand_bytes(Bytes))).

get_random_string(Length, AllowedChars) ->
    lists:foldl(fun(_, Acc) ->
                        [lists:nth(rand:uniform(length(AllowedChars)),
                                   AllowedChars)]
                            ++ Acc
                end, [], lists:seq(1, Length)).


start() ->

    Random_str_size = 5,
    UFname = "mbudhwani",
    Allowed_char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()",

    %Random string
    Random_str = get_random_string(Random_str_size,Allowed_char),

    %Concatenated String
    Final_str = concat(UFname,Random_str),
    %io:format("~s~n",[Random_str]),
    io:format("Concatenated String:  ~s~n",[Final_str]),

    %Hashed String
    io:format(io_lib:format("Hashed String: ~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,Final_str))])).




