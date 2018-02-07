-module(monitor).
-compile(export_all).

start() ->
    register(monitor_atom, spawn(fun() -> loop() end)),
    Double_process = double:start(),
    Ref = erlang:monitor(process, Double_process).


loop()  ->
    receive
        {'DOWN', Ref, process, Double_process, Info} ->
            io:format("Info is -------------> ~p~n",[Info]),
        loop()
    end.