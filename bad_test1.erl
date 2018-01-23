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