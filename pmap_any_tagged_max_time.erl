-module(pmap_any_tagged_max_time).
-export([pmap_any_tagged_max_time/3]).


smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].



pmap_any_tagged_max_time(F, L, MaxTime)    ->
    S = self(),
    Pids = smap(fun(I) ->
        spawn(fun() -> do_f(S, F, I) end)
        end, L),
        
    %% gather the results
    gather(Pids, MaxTime).

kill_em([]) ->
    dead;

kill_em([H|T]) ->
    io:format("HÄR ÄR: ~p~n", [H]),
    exit(H, kill),
    kill_em(T).


do_f(Parent, F, I) ->
    io:format("Jag heter: ~p~n", [self()]),
    Parent ! {self(), { I , (catch F(I))}}.

gather([], _MaxTime) ->
    [];
gather(List, MaxTime) ->
    receive 
        {Pid, Ret}      ->
        case lists:member(Pid, List) of
            true    -> [Ret|gather(lists:delete(Pid, List), MaxTime)];
            false   -> gather(List, MaxTime)

        end
    after MaxTime   ->
        kill_em(List),
        []
        
    end.