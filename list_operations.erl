-module(list_operations).

% By: Johan Eklundh, joek9694
%
% To run all tests, run primes:all_test/0. 

-export([seq/1, filter/2, rotate/2, test_seq/0, test_filter/0, 
	test_rotate/0]).

%----------------- Tests-------------------------------

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
	Num = length(L) + N,	%% X + (-Y) = X - Y
	rotate(Num, L);
	
rotate(N, L) when is_integer(N)-> 	%% Never rotate more than length of L -1. 	
	rotate(N rem length(L),L).