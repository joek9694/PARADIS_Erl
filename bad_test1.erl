-module(bad_test1).

%
%   This program had a number of errors, which should now be fixed.
%   Running bad_prog1:test_all() should return the atom 'hooray'
%

-import(math, [pi/0, pow/2]).
-compile(export_all).



%% --------- Tests.

test_double() ->
	4 = double(2),
	-4 = double(-2),
	0 = double(0),
	{'EXIT',_} = (catch double([])),
	hooray.

%%	io:format("double(2) is ~p, and should be 4 ~n",[double(2)]),
%%	io:format("double(-2) is ~p, and should be -4 ~n",[double(-2)]),
%%	io:format("double(0) is ~p, and should be 0 ~n",[double(0)]),
%%	hooray.
	
test_factorial() ->
	1 = factorial(0),
	1 = factorial(1),
	24 = factorial(4),
	{'EXIT', _Why} = (catch factorial(-1)),
	{'EXIT', _Why2} = (catch factorial("")),
	hooray.	
	
test_area() ->
	100 = area({square, 10}),
	6 = area({rectangle, 2, 3}),
	-6 = area({rectangle, 2, -3}),
	3.141592653589793 = area({circle, 1}),
	12.566370614359172 = area({circle, 2}),
	12.566370614359172 = area({circle, -2}),
	0.0 = area({circle, 0}),
	hooray.
	
test_perimeter() -> 
	8 = perimeter({rectangle, 2, 2}),
	10 = perimeter({rectangle, 2, 3}),
	0 = perimeter({rectangle, -2, 2}),
	-2 = perimeter({rectangle, 2, -3}),
	-8 = perimeter({rectangle, -2, -2}),
	
	-8 = perimeter({square, -2}),
	8 = perimeter({square, 2}),
	
	ok = perimeter("wrong input").

	
	
%%	io:format("factorial(0) is ~p, and should be 1 ~n",[factorial(0)]),
%%	io:format("factorial(1) is ~p, and should be 1 ~n",[factorial(1)]),
%%	io:format("factorial(4) is ~p, and should be 24 ~n",[factorial(4)]),
%%	{'EXIT', Why} = (catch factorial(-1)),
%%	{'EXIT', _Why2} = (catch factorial("")),
%%	io:format("~p ~n",[Why]),
%%	hooray.

test_all2() ->
	test_double(),
	test_factorial(),
	test_area(),
	test_perimeter(),
	hooray.

test_all() ->
    10 = double(5),
    100 = area({square,10}),
    44 = perimeter({square,11}),
	44 = perimeter({rectangle,11,11}),		%added serparate test for tuple with 3 elements
%%    melting point of sulfur 
    {f,212.0} = temperatuer_convert({c,100.0}), 
    120 = factorial(5),
    hooray.

	
%% --------- Random mathematical equations.
	
double(X) ->
    2*X.
	
	
factorial(0) -> 
	1;
factorial(N) when N > 0 -> 
	N* factorial(N-1).

	
%% --------- Calculations on geometric figures.
	
area({square,X}) ->
    X*X;
area({rectangle,X,Y}) ->
    X*Y;
%%negative input 
area({circle,R}) ->	
	 math:pi() * math:pow(R,2).
	
	
perimeter(InTupple) ->
    case InTupple of
        {rectangle,X,Y} ->
             2*(X+Y);
		{square,X} ->
             4*X;
        _ -> io:format("cannot compute the perimeter of ~p ~n", [InTupple])
			
	end.

	
%% ---------- temperature conversion.
%%(without guards for below absolute zero conversions,
%% since there (since 2013) are quantum gas with measured 
%% sub-absolute-zero temperatures.
%% using formula 5(F-32) /9 = C

temperatuer_convert({c,C}) ->
	F = (9*C) /5 + 32,
	{f,F};

temperatuer_convert({f,F}) ->
	C = 5 *(F -32) /9,
	{c,C}.