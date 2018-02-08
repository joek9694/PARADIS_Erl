-module(pmap_try).

pmap_max(F, L, MaxWorkers) when MaxWorkers > 0 -> 
    pmap_max(F, L, MaxWorkers, 0).

pmap_max(_F, [], _MaxWorkers, 0) 
    -> [];
pmap_max(F, [], MaxWorkers, Count) ->
    receive
        R -> 
            io:format("Receiving process ~p~n", [Count]),
            [R | pmap_max(F, [], MaxWorkers, Count-1)]
    end;
pmap_max(F, [H|T], MaxWorkers, Count) when Count < MaxWorkers ->
    io:format("Spawning process ~p~n", [Count+1]),
    S = self(),
    spawn(fun() -> S ! F(H) end),
    pmap_max(F, T, MaxWorkers, Count+1);
pmap_max(F, L, MaxWorkers, MaxWorkers) -> 
    receive
        R -> 
            io:format("Receiving process ~p~n", [MaxWorkers]),
            [R | pmap_max(F, L, MaxWorkers, MaxWorkers-1)]
    end.
