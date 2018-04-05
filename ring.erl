-module(ring).

%% By Johan Eklundh, JoEk9694
%%
%%

-export([start/2]).


start(N, M) ->
    io:format("I am: ~p~n", [self()]),
    Pid = build(N, self()),
    
    loop(M, Pid),
    exit(Pid, kill).

loop(0, _Pid) ->
    receive
        {increment, X} ->
        X
    end;

loop(M, Pid)  ->
    Pid ! {increment, 0},
    io:format("~p, skickar till: ~p~n", [self(),Pid]),
    receive
        {increment, X} ->
            Pid ! {increment, X +1},
            io:format("Hello3 ~n"),
            loop(M -1, Pid)
    end.

build(1, Host) ->
   %% Pid = spawn_link(fun() -> ring(Host) end),
   %% io:format("build/1 ~p~n", [Pid]),
   %% Pid;
   io:format("build/1 ~p~n", [Host]),
   Host;


build(Links, Host) ->
    Pid = spawn_link(fun() -> ring(build (Links -1, Host)) end),
    io:format("build/2 ~p~n", [Pid]),
    Pid.

ring(NextPid) ->
    receive
        {increment, X} ->
        io:format("~p, X is: ~p skickar till : ~p~n", [self(), X, NextPid]),
            NextPid ! {increment, X +1},
        ring(NextPid)
    end.



    

