-module(bitcoinmining).
-export([findCoin/4,start/1,boss/5,bossReceive/1,getString/2,concat/2]).
-import(crypto,[hash/2,rand_uniform/2]).
-import(timer, [now_diff/2]).

getString(0,String) ->
    String;
getString(N,String)->
    CharsList = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
    Char = lists:nth(rand:uniform(length(CharsList)),CharsList),
    
    getString(N-1, String ++ [Char]).

concat(64, String)->
    String;
concat(CurrentLen,String)->
    concat(CurrentLen+1,"0"++String).

findCoin(0,K,UFID,PID)->
    PID ! {finished};

findCoin(N,K,UFID,PID)->
    RandomString = getString(5,UFID),
    HashVal = crypto:hash(sha256,[RandomString]),
    HashValInteger = crypto:bytes_to_integer(HashVal),
    HashValHex = integer_to_list(HashValInteger, 16),
    %io:format("size ~w~n",[length(HashValHex)]),
    if
        length(HashValHex) =< (64-K)->
            %io:format("TrueeString ~p and HASH VALUE: '~p' ~n" ,[RandomString,concat(length(HashValHex), HashValHex)]), 
            PID ! {RandomString,HashValHex},
            findCoin(N-1,K,UFID,PID);
        true->
            findCoin(N,K,UFID,PID)
            %io:format("~w",[byte_size(HashVal)])
    end.


boss(NoOfNodes,N,K,UFID,PID)->
    findCoin(N,K,UFID,self()),
    bossReceive(NoOfNodes).

bossReceive(0)->
    main ! {erlang:timestamp()};
    %io:format("~n~nCompleted~n"),
    %exit(self(), normal);
    
bossReceive(NoOfNodes)->
    receive
    {finished} ->
        %io:format("finished"),
        bossReceive(NoOfNodes-1);
    {Input,Output} ->
        io:format("~p \t ~p ~n" ,[Input,concat(length(Output), Output)]),
        bossReceive(NoOfNodes)
end.

initializeWorkers([],NStrings, K, UFID,PIDmaster) ->
    %io:format("All workers given work");
    0;

initializeWorkers([Node1|NodeList],NStrings, K, UFID,PIDmaster)  ->
    ID = spawn_link(Node1,bitcoinmining,findCoin,[NStrings,  K, UFID, PIDmaster]),
    initializeWorkers(NodeList,NStrings, K, UFID,PIDmaster).
    

start(K)->
    TimeStart = erlang:timestamp(),
    register(main,self()),
    
    UFID = "awadhwani",
    NodeList = nodes(),
    %io:format("~w~n",[NodeList]),
    NStrings = 32 div (length(NodeList)+1),
    PIDmaster = spawn(bitcoinmining,boss,[length(NodeList)+1,NStrings, K, UFID, self()]),

    initializeWorkers(NodeList,NStrings, K, UFID,PIDmaster),

    receive
        {TimeEnd} ->
            io:format("Time taken ms : ~w~n",[timer:now_diff(TimeEnd,TimeStart)])
        end,

    %io:format("~w~n",statistics(runtime)),
    unregister(main).