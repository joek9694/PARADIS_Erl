-module(double).
%% By: Johan Eklundh, JoEk9694
%%
%% Run test_message to try, or run start and send the process a message.

-export([start/0, test_message/0, clear/0]).  

%% Start/0 can only be ran ones, since the registered atom is hardcoded. This is due to how 
%% how the assignment was formulated. Use clear/0 to unregister atom.
start()  ->
    register(double, spawn(fun() -> loop() end)).


test_message() ->
    start(),
    double ! 2,
    clear().

%% Unregisters the atom double, so that start/0 can be run again.
clear() ->
    double ! {clear},
    unregister(double).


%% Receiverloop that returns double the value of received integer or an error if message
%% doesn't contain an integer.
loop() ->
    io:format("I am: ~p~n", [self()]),
    receive
        {clear} ->
            ok;

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

%% Returns X times 2, where X is an integer.
double(X) when is_integer(X)->
    X*2.