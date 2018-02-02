-module(primes).

%% By: Johan Eklundh, joek9694
%%
%% Run all_tests() to go through all tests related to 
%% this module (primes) and the module list_operations.	

-import(list_operations, [seq/1, filter/2, rotate/2, test_seq/0, test_filter/0, 
	test_rotate/0]).
-export([is_prime/1, all_primes/1,
	all_tests/0, test_is_prime/0, test_all_primes/0]).	

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

%--------------------- all_primes ------------------------
%% Takes an integer as an argument. Returns a list of all primes up to N.
%% Returns empty list if N is to low.
all_primes(N) when is_integer(N) ->
	filter(fun is_prime/1, seq(N)).
	