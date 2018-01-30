-module(assign2).

%-compile(export_all).
-export([is_prime/1, seq/1, filter/2, rotate/2, all_primes/1]).	

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
		
seq(N) when N > 0 ->
	seq(1,N).

seq(N, N) ->
	[N];
	
seq(X,N) when X < N ->
	[X|seq(X+1, N)].
	
filter(F,L) ->
	[X || X <- L , F(X)].
	
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

all_primes(N) ->
	filter(fun is_prime/1, seq(N)).
	