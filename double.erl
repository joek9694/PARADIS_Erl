-module(double).
%% By: Johan Eklundh, JoEk9694
%%
%% Run test_message/0 to try, or run start/0 and send the process a message.

-export([start/0, test_message/0, clear/0]).  

test_message() ->
    start(),
    double ! 2,
    clear(),
    start(),
    double ! 4,
    clear(),
    start(),
    double ! -2,
    clear().

%% Start/0 can only be ran ones, since the registered atom is hardcoded. This is due to how 
%% how the assignment was formulated. Use clear/0 to unregister atom.
start()  ->
    register(double, spawn(fun() -> loop() end)).

%% Unregisters the atom double, so that start/0 can be run again.
clear() ->
    double ! {clear},
    unregister(double).


%% Receiverloop that returns double the value of received integer or an error if message
%% doesn't contain an integer.
loop() ->
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