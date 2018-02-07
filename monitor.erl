-module(monitor).
-export([start/0]).


start() -> 
    MonitorPid = spawn(fun() -> monitor() end),
    io:format("THE MONITORPID: ~p~n", [MonitorPid]).        %% Clean up

monitor() ->
    double:start(),     %% process registered as 'double'
    monitor(process, double),
    loop().

loop()  ->
    receive 
        {'DOWN', Ref, process, Pid, Info} ->
            io:format("Error: ~p~n", [Info]),               %% Clean up
            double:start(),
            monitor(process, double),
            loop()
    end.
