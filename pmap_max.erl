-module(pmap_max).
-export([pmap_max/3]).

%% smap(F, L)(sequential map) maps a function F over a list of items L
%% can be defined as follows:
smap(_, []) -> [];
smap(F, [H|T]) -> [F(H) | smap(F, T)].


pmap_max(F, L, MaxWorkers) ->
    Sub = lists:sublist(L, MaxWorkers),
    Rest = lists:subtract(L,Sub),

    S = self(),
    Pids = helper(S, F, Sub),    
        gather(Pids, Rest, F).   %% L

helper(S, F, List)    ->
    smap(fun(I) ->
        spawn(fun() -> do_f(S,F,I) end) 
        end, List).

do_f(Parent, F, I) ->
    Parent ! {self(), (catch F(I))}.

gather([Pid|T], [Pid2|Rest], F) ->      %% , [H|T2]
    receive
        {Pid, Ret} -> Arg1T = T ++ helper(self(),F,[Pid2]),
            [Ret| gather(Arg1T, Rest, F)]  %% T addLast H
    end;

gather([Pid|T], [], F) ->      %% , [H|T2]
    receive
        {Pid, Ret} -> Arg1T = T ++ helper(self(),F,[]),
            [Ret| gather(Arg1T, [], F)]  %% T addLast H
    end;

gather([], [], _F) ->   %% ???
    [].
