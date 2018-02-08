-module(pmap_any).
-export([pmap_any/2, fib/1]).

%% smap(F, L) (sequential map) maps a function F over a list of items L
%% can be defined as follows:
smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].


%% A parallel version pmap(F,L) can be written as follows:

pmap_any(F, L) ->
    S = self(),
    Pids = smap(fun(I) ->
        spawn(fun() -> do_f(S, F, I) end)
        end, L),
        
    %% gather the results
    gather(Pids).

do_f(Parent, F, I) ->
    Parent ! {self(), (catch F(I))}.

gather([]) ->
    [];
gather(List) ->
    receive 
        {Pid, Ret} ->
        case lists:member(Pid, List) of
            true -> [Ret|gather(lists:delete(Pid, List))];
            false -> gather(List)
        end
    end.


fib(0) -> 0;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).



%% There, are many varients on this simple pattern, so in these exercises
%% you will write a number of parallel mapping functions.