-module(ring).
-export([start/2]).


start(N, M) ->
    Pids = spawn_loop(N, []).


spawn_loop(N, Pids) when N > 0 ->
    NewPids = [spawn(?MODULE, ring_send, [N,M])|Pids],
    spawn_loop(N-1, NewPids);

spawn_loop(0, Pids) ->
    Pids.

ring_send(Members, Laps) ->
    

