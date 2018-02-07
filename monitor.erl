-module(monitor).
-export([start/0]).


start() -> 
    MonitorPid = spawn(fun() -> monitor() end),
    io:format("THE MONITORPID: ~p~n", [MonitorPid]).

monitor() ->
    double:start(),     %% double
    monitor(process, double),
    loop().

loop()  ->
    receive 
        {'DOWN', Ref, process, Pid, Info} ->
            io:format("Error: ~p~n", [Info]),
            double:start(),
            monitor(process, double),
            loop()
    end.
