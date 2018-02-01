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
%% Runs all tests, return 'hooray' if succesful.
all_tests() ->
	test_is_prime(),
	test_seq(),
	test_filter(),
	test_rotate(),
	test_all_primes(),
	hooray.


%% Tests is_prime by boolean values, if the prime evaluation returns false 
%% where the oracle says its true the test throws an exception error: "no match
%% of right hand side value ... ". Returns 'hooray' if succesful. 
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

%%  FIX_ME
test_seq()->
	fix_me.


% FIX_ME
test_filter() ->
	fix_me.


%FIX_ME
test_rotate() ->
	fix_me.


%FIX_ME
test_all_primes() ->
	fix_me.


	

%---------------------- is_prime -----------------------
is_prime(2) ->
	true;

is_prime(N) when N rem 2 =:= 0->
	false;
	
is_prime(N) when N < 2 ->
	false;

is_prime(N) ->
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
seq(N) when N > 0 ->
	seq(1,N).

seq(N, N) ->
	[N];
	
seq(X,N) when X < N ->
	[X|seq(X+1, N)].

%----------------------- filter ---------------------------
filter(F,L) ->
	[X || X <- L , F(X)].


%----------------------- rotate --------------------------
rotate(1,L) ->
	[H|T] = L,
	T ++ [H];

rotate(N, L) when N > 0, N <(length(L)) ->
	[H|T] = L,
	rotate(N-1, T ++ [H]);

rotate(N, L) when N == 0 ->	%% No rotations
	L;

rotate(N, L) when N < 0, N > (length(L)* -1) ->
	Num = length(L) + N,	%% positiveNum + negativeNum = lessThanPositiveNumber
	rotate(Num, L);
	
rotate(N, L) -> 			%% N = to big or to small 	
	rotate(N rem length(L),L).

%--------------------- all_primes ------------------------
all_primes(N) ->
	filter(fun is_prime/1, seq(N)).
	