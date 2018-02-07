-module(double).

-export([start/0]). 

start()  ->
    register(double, spawn(fun() -> loop() end)).


loop() ->
    io:format("I am: ~p~n", [self()]),
    receive
        X ->
            try 
                Result = double(X),
                io:format("The result is: ~p~n", [Result]),
                loop()
            catch
                _:Why ->
                erlang:error(Why)
            end

    end.


double(X) when is_integer(X)->
    X*2.