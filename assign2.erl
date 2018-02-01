-module(assign2).


%%	By: Johan Eklundh, joek9694
%%
%%
%% Run all_tests() to go through all tests.	



%-compile(export_all).
-export([is_prime/1, seq/1, filter/2, rotate/2, all_primes/1,
	all_tests/0, test_is_prime/0, test_seq/0, test_filter/0, 
	test_rotate/0, test_all_primes/0]).	

%---------------------- Tests -------------------------
%% Runs all tests, return 'hooray' if successful.
all_tests() ->
	test_is_prime(),
	test_seq(),
	test_filter(),
	test_rotate(),
	test_all_primes(),
	hooray.


%% Tests is_prime/1 by boolean values, if the prime evaluation returns false 
%% where the oracle says its true the test throws an exception error: "no match
%% of right hand side value ... ". Returns 'hooray' if successful. 
test_is_prime() ->
	{'EXIT', _} = (catch is_prime("wrong input")),

	false = is_prime(-1),
	false = is_prime(0),
	false = is_prime(1),
	false = is_prime(4),
	false = is_prime(15),
	

	true = is_prime(2),
	true = is_prime(3),
	true = is_prime(5),
	true = is_prime(7),
	true = is_prime(11),

	true = is_prime(257),
	true = is_prime(3313),
	true = is_prime(10007),
	true = is_prime(100109),

	hooray.

%% Tests seq/1 so that it returns an ascending list of integers if input is
%% greater than 1 and a descending list if input is less than 1. Returns 
%% 'hooray' if successful.
test_seq()->
	[1,0,-1,-2,-3] = seq(-3),
	[1,0,-1] = seq(-1),
	[1,0] = seq(-0),

	[1] = seq(1),

	[1,2,3] = seq(3),
	[1,2,3,4,5,6,7,8,9,10] = seq(10),
	hooray.

%% Tests filter/2 with different functions and lists. 
%% Returns [hooray] if successful. 
test_filter() ->
	List = [1,2,3,4,5,6,7,8,9,10],
	ABC = ["a","b","c","d","e"],
	Zoo = [{monkey}, {kangaroo}, {grizzley}],
	Hooray = [hooray],

	[] = filter(2+2, []),

	[2,4,6,8,10] = filter(fun(X) -> X rem 2 =:= 0 end , List),
	[3,6,9] = filter(fun(X) -> X rem 3 =:= 0 end , List),
	[5,10] = filter(fun(X) -> X rem 5 =:= 0 end , List),

	["a","b","c"] = filter(fun(X) -> X < "d" end , ABC),

	filter(fun(X) -> X =:= {monkey} end , Zoo),

	filter(fun(X) -> X =:= hooray end , Hooray).

% Tests rotate/2, returns 'hooray' if successful.
test_rotate() ->
	List = [1,2,3,4,5],
	[3,4,5,1,2] = rotate(2 ,List),
	[4,5,1,2,3] = rotate(-2 ,List),
	[1,2,3,4,5] = rotate(10 ,List),
	Big_Number = 1000000000000000000000, %% 10 to the power of 21.
	Small_Number = -1000000000000000000000, %% 10 to the power of 21 * -1 .
	[1,2,3,4,5] = rotate(Big_Number ,List),
	[1,2,3,4,5] = rotate(Small_Number ,List),
	hooray.

% Tests all_primes/1 against oracle up to 499. Returns 'hooray' if succesful.
test_all_primes() ->
	[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 
	31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 
	73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 
	127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 
	179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 
	233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 
	283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 
	353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 
	419, 421, 431, 433, 439, 443, 449, 457, 461, 463,
	467, 479, 487, 491, 499] = all_primes(500),

	[] = all_primes(-1),

	hooray.

%---------------------- is_prime -----------------------
%% Takes one argument which must be an integer and evaluates
%% if it's a prime or not. Returns true 
%% if argument is a prime number, false if not. 
is_prime(2) ->
	true;

is_prime(N) when N rem 2 =:= 0->
	false;
	
is_prime(N) when N < 2 ->
	false;

is_prime(N) when is_integer(N)->
	is_prime(N,3, math:sqrt(N)).

is_prime(_N, Current, Max) when Current > Max ->
	true;
	
is_prime(N, Current, Max) ->
	if 
		N rem Current =:= 0 ->
		false;

		true ->
		is_prime(N, Current +2, Max)
	end.


%------------------------- seq ---------------------------
%% Produces a list containing a sequence of integers, from 1 to N.
seq(N) when is_integer(N) ->
	seq(1,N).

seq(N, N) ->
	[N];
	
seq(X,N) when X < N ->
	[X|seq(X+1, N)];

seq(X,N) when X > N ->
	[X|seq(X-1, N)].

%----------------------- filter ---------------------------
%% Takes a function (F) as first argument and a list (L) as second argument.
%% Returns a list of all elements X in list L where 
%% X is a function of F, read as: F(X). 
%% Returns empty list if given [] as second argument.
%% Throws "no function clause matching"- errors
filter(F,L) ->
	[X || X <- L , F(X)].


%----------------------- rotate --------------------------
%% Takes an integer as first argument and a list as second argument.
%% Rotates, list (L), the second argument one element at a time. Rotates as 
%% many elements as given by first argument and rotates no more than the 
%% length of L -1. 
%% If N is a positive integer: rotations are done by moving the first 
%% element to the last position. If N is a negative integer rotations 
%% are done by moving the last element to the first position in the list. 

rotate(1,L) ->
	[H|T] = L,
	T ++ [H];

rotate(N, L) when is_integer(N), N > 0, N < (length(L)) ->
	[H|T] = L,
	rotate(N-1, T ++ [H]);

rotate(N, L) when is_integer(N), N == 0 ->	%% No rotations
	L;

rotate(N, L) when is_integer(N), N < 0, N > (length(L)* -1) ->
	Num = length(L) + N,	%% positiveNum + negativeNum = lessThanPositiveNumber
	rotate(Num, L);
	
rotate(N, L) when is_integer(N)-> 	%% Never rotate more than length of L -1. 	
	rotate(N rem length(L),L).

%--------------------- all_primes ------------------------
%% Takes an integer as an argument. Returns a list of all primes up to N.
%% Returns empty list if N is to low.
all_primes(N) when is_integer(N) ->
	filter(fun is_prime/1, seq(N)).
	