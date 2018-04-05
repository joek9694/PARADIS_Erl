-module(monitor).

%% By: Johan Eklundh, JoEk9694
%%
%% Run start/0 to start monitor and double, allowing normal interaction with double, including
%% the start of a new double process if dead by error.
%% Run test_monitor/0 to go through tests.
%% Close double with normal exit signal to close monitor, can be done by using double:clear().


-export([start/0, test_monitor/0]).

%% Hur ska denna testas?? Känner ju inte till double..

%% V1: Very forced testing, where process is delayed by printing, so that (hopefully),
%% the process running the double loop has time to calculate and pass message before next message.
%% This is done since the double module, has no receive - answer semantics. 

%% V2: Better, testing with delays so that other process is done, 
%% by the time next message is sent.
test_monitor() ->
    start(),
    %io:format("~p is delaying alittle...~n", [Pid]),
    %io:format("~p then trying to send to double...~n", [Pid]),
    timer:sleep(1000),
    double ! 2,
    %io:format("~p is delaying alittle...~n", [Pid]),
    %io:format("~p then trying to send to double...~n", [Pid]),
    timer:sleep(1000),
    double ! c,
    %io:format("~p is delaying alittle...~n", [Pid]),
    %io:format("~p is delaying alittle...~n", [Pid]),
    %io:format("~p is delaying alittle...~n", [Pid]),
    %io:format("~p then trying to send to double...~n", [Pid]),
    timer:sleep(1000),
    double ! 2,
    %io:format("~p is delaying alittle...~n", [Pid]),
    %io:format("~p then closing...~n", [Pid]),
    timer:sleep(1000),
    double:clear(),
    hooray.
    


start() -> 
    spawn(fun() -> monitor() end).

monitor() ->
    double:start(),     %% process registered as 'double'
    monitor(process, double),
    loop().

loop()  ->
    receive 
        {'DOWN', Ref, process, _Pid, normal} ->             %% Ends monitor-loop
            io:format("Error: ~p~n", [normal]),               
            io:format("closing down ~n"),
            demonitor(Ref);
            
        {'DOWN', _Ref, process, _Pid, Info} ->
            io:format("Error: ~p~n", [Info]),               %% Prints error message
            io:format("starting new double process... ~n"), 
            double:start(),                                 %% Starts new double process
            monitor(process, double),
            loop()

    end.
