-module(bad_test1).
-import(math, [pi/0, pow/2]).

%
%   This program has a number of errors
%   find them and fix them.
%   Once you have fixed the code
%   run some text examples to see if the fuctions
%   behave as expected
%   Running bad_prog1:test() should return the atom 'hooray'
%

-compile(export_all).

%test_all() ->
%    10 = double(5),
%    100 = area({square,10}),
%    44 = perimeter({square,10}),
%    // melting point of sulfur 
%    {f,212} = temperatuer_convert({c,100}), 
%    120 = factorial(4),
%    hooray.

factorial(0) -> 1;
factorial(N) when N > 0 -> N* factorial(N-1).

test1() ->
    io:format("double(2) is ~p~n",[double(2)]).
	
double(X) ->
    2*X.
	
area({square,X}) ->
    X*X;
area({rectangle,X,Y}) ->
    X*Y;
area({circle,R}) ->	
	 math:pi() * math:pow(R,2).