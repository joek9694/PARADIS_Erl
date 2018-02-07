-module(monitorEx).
-export([start/0, loop/0]).


start() -> spawn(fun() -> main() end).

main() ->
    spawn_monitor(fun() -> simple_process(5) end),
    loop().


loop() ->
    receive 
    {'DOWN', _Ref, process, Pid, _Reason} ->
        io:format("~p down...~n", [Pid]),
        spawn_monitor(fun() -> simple_process(5) end),
        ?MODULE:loop()
    end.


simple_process(Seconds) ->
    io:format("Simple process running... ~p~n", [self()]),

    receive 
    after Seconds *1000 ->
        ok
    end.
