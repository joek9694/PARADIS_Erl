-module(ring2).
-export([start/2]).


start(N, M) ->
    Pids = spawn_loop(N, []),
    send_round(0, Pids, M, self()),
    receive
        {response, X} ->    %% Dont forget to kill all processess
        io:fomat("4 received by: ~p~n", [self()]),
            X 
    end.

spawn_loop(0, Pids) ->
    Pids;

spawn_loop(N, Pids) when N > 0 ->
    NewPids = [spawn_link(?MODULE, spawn_loop, [N, Pids])|Pids],
    spawn_loop(N-1, NewPids).


send_round(Int, Pids, M, Host) ->
    [Pid| Rest] = Pids,
    Pid ! {increment, Int, Rest, Pids, M, Host}.


receive_send() ->
    receive
        {increment, X, _, Pids, 0, Host}     ->
            io:fomat("1 received by: ~p~n", [self()]),
            Host ! {response, X},
            receive_send();        

        {increment, X, [], Pids, M, Host}    ->
            io:fomat("2 received by: ~p~n", [self()]),
            NewX = X + 1,
            NewM = M - 1,
            send_round(NewX, Pids, NewM, Host),
            receive_send();

        {increment, X, List, Pids, M, Host}  ->
            io:fomat("3 received by: ~p~n", [self()]),
            NewX = X +1,
            send_round(NewX ,List, M, Host),
            receive_send()
    end.


    

