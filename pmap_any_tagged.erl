-module(pmap_any_tagged).
-export([pmap_any_tagged/2]).

smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].



pmap_any_tagged(F, L)    ->
    S = self(),
    Pids = smap(fun(I) ->
        spawn(fun() -> do_f(S, F, I) end)
        end, L),
        
    %% gather the results
    gather(Pids).

do_f(Parent, F, I) ->
    Parent ! {self(), { I , (catch F(I))}}.

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