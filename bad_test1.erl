-module(bad_test1). %% försök till lösning på bad_prog1

% By: JoEk9694, Johan Eklundh
%
%   This program had a number of errors, which should now be fixed.
%   Running bad_prog1:test_all() should return the atom 'hooray'
%

-import(math, [pi/0, pow/2]).
-compile(export_all).



%% --------- Tests.

%% Run test_all() for all tests.
test_double({_, X}) ->
	X.

test_double() ->
	4 = double(2),
	-4 = double(-2),
	0 = double(0),
	{'EXIT',_} = (catch double([])),
	hooray.
	
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
	
	{'EXIT', _Why} = (catch area({circle, "wrong input"})),
	hooray.
	
	
test_perimeter() -> 
	8 = perimeter({rectangle, 2, 2}),
	10 = perimeter({rectangle, 2, 3}),
	0 = perimeter({rectangle, -2, 2}),
	-2 = perimeter({rectangle, 2, -3}),
	-8 = perimeter({rectangle, -2, -2}),
	
	-8 = perimeter({square, -2}),
	8 = perimeter({square, 2}),
	
	ok = perimeter("wrong input"),
	hooray.
	
	
%% Temperature conversions rounded to 2 decimalpoints.
test_temperature_convert() ->
	{c, 0.0} = temperatuer_convert({f, 32.0}),
	{c, -17.78} = temperatuer_convert({f, 0.0}),
	{f, 68.00} = temperatuer_convert({c,20}),
	{c, 20.0} = temperatuer_convert({f,68.0}),
	{f, -459.67} = temperatuer_convert({c, -273.15}),
	{c, -273.15} = temperatuer_convert({f, -459.67}),
	
	{'EXIT', _Why} = (catch temperatuer_convert({f, "wrong input"})),
	
	hooray.


test_all() ->
	test_double(),
	test_factorial(),
	test_area(),
	test_perimeter(),
	test_temperature_convert(),
	hooray.


	
%% --------- Random mathematical equations.
	
double(X) ->
    2*X.
	
	
factorial(0) -> 
	1;
factorial(N) when N > 0 -> 
	N* factorial(N-1).

	
%% --------- Calculations on geometric figures.

%% accepts negative numbers as input


area({square,X}) ->
    X*X;
area({rectangle,X,Y}) ->
    X*Y; 
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
%% Using formula 5(F-32) /9 = C, 
%% presented using 2 decimal points.

temperatuer_convert({c,C}) ->
	F = (9*C) /5 + 32,
	Farenheit = list_to_float(float_to_list(F,[{decimals, 2}])),
	{f,Farenheit};

temperatuer_convert({f,F}) ->
	C = 5 *(F -32) /9,
	Celsius = list_to_float(float_to_list(C,[{decimals, 2}])),
	{c,Celsius}.