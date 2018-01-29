-module(assign2).

-compile(export_all).
			
is_prime(N) when N =< 10000 ->
	
	if 
		N =< 1 ->
			false;
	
		true ->
			L = lists:seq(3, N , 2),
			Rot = round(math:sqrt(N)),
			Prime_list = primes(2, Rot, [], L),
			N =:= lists:last(Prime_list)
	end.
	
primes(P, Max, Primes, L) when P > Max ->
	lists:reverse([P|Primes]) ++ L;
	
primes(P, Max, Primes, L) ->
	[NewPrime| NewList] = [X || X <- L, X rem P =/= 0],
	primes(NewPrime, Max, [P|Primes], NewList).

seq(N) when N > 0 ->
	seq(1,N).

seq(N, N) ->
	[N];
	
seq(X,N) when X < N ->
	[X|seq(X+1, N)].
	
filter(F,L) ->
	implement_this.

	
all_primes(N)->
	implement_this.
	
rotate(N,L) ->
	implement_this.
	
