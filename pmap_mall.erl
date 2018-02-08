-module(pmap_mall).
-compile(export_all).

%% smap(F, L) (sequential map) maps a function F over a list of items L
%% can be defined as follows:
smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].


%% A parallel version pmap(F,L) can be written as follows:

pmap(F, L) ->
    S = self(),
    Pids = smap(fun(I) ->
        spawn(fun() -> do_f(S, F, I) end)
        end, L),
        
    %% gather the results
    gather(Pids).

do_f(Parent, F, I) ->
    Parent ! {self(), (catch F(I))}.

gather([Pid|T]) ->
    receive
        {Pid, Ret} -> [Ret|gather(T)]
    end;
gather([]) ->
    [].

%% There, are many varients on this simple pattern, so in these exercises
%% you will write a number of parallel mapping functions.