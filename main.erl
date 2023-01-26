-module(main).
-import(string,[substr/3,concat/2,to_string/1]). 
-export([start/0,get_random_string/2,mine_coin/0,loop/1,check_if_coin/2]).
%-compile(export_all).

%-define (UFname,"mbudhwani").
 
%gen_random_str(Bytes) ->
%    io:fwrite(base64:encode(crypto:strong_rand_bytes(Bytes))).

get_random_string(Length, AllowedChars) ->
    lists:foldl(fun(_, Acc) ->
                        [lists:nth(rand:uniform(length(AllowedChars)),
                                   AllowedChars)]
                            ++ Acc
                end, [], lists:seq(1, Length)).


check_if_coin(Hashed_string,InputK) ->
    Substring = substr(Hashed_string,1,InputK),
    StringofZeros = "000000000000000000000000000000",
    %io:format("Substring: ~s~n",[Substring]),

    %io:format("InputK: ~p~n",[InputK]),
    %String1 = to_string(lists:foreach(fun(_) ->io:format("0") end, lists:seq(1, InputK))),
    %String1 = lists:foreach(fun(_) ->io:format("0") end, lists:seq(1, InputK)),

    %String1 = "00",
    String1 = substr(StringofZeros,1,InputK),
    %io:format("String1: ~s~n",[String1]),
    if 
            Substring == String1 ->
                %io:format("Concatenated String:  ~s~n",[Final_str]),
                io:format("Hashed String: ~s~n",[Hashed_string]);
            true ->
                ok
        end.

mine_coin() ->
    receive
        {UFname,Random_str_size,InputK} ->
        Allowed_char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()",
        %Random string
        Random_str = get_random_string(Random_str_size,Allowed_char),

        %Concatenated String
        Final_str = concat(UFname,Random_str),
        %io:format("~s~n",[Random_str]),
        %io:format("Concatenated String:  ~s~n",[Final_str]),

        %Hashed String
        Hashed_string = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,Final_str))]),
        %io:format("Hashed String: ~s~n",[Hashed_string]),

        check_if_coin(Hashed_string,InputK),

        mine_coin()
    end.

loop(0) ->
    ok;
loop(Count) ->
    %Mining Coins 
    Random_str_size = 8,
    UFname = "mbudhwani",
    InputK = 4,
    Pid = spawn(fun() -> mine_coin() end),
    %io:format("Process ID ~p: ~p~n",[Count,Pid]),
    Pid ! {UFname,Random_str_size,InputK},
    %io:fwrite("Loop"),
    loop(Count - 1).

start() ->
    %InputK = 10,
    %String1 = string:strip(lists:foreach(fun(_) -> io:fwrite("0") end, lists:seq(1, InputK))),
    %io:format("~s",[String1]).
    %String1.
    %String1.
    loop(100000).


