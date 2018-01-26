-module(bank1).
-compile(export_all).

test() ->
    Pid = new(),
    ok = add(Pid, 10),
    ok = add(Pid, 20),
    30 = balance(Pid),
    ok = withdraw(Pid, 15),
    15 = balance(Pid),
    insufficient_funds = withdraw(Pid, 20),
    horray.

new() ->
    spawn(fun() -> bank(0) end).

balance(Pid) ->
    rpc(Pid, {balance}).

add(Pid, X) -> 
	rpc(Pid, {add, X}).

withdraw(Pid, X) ->
	rpc(Pid, {withdraw, X}).

rpc(Pid, X) ->
    Pid ! {self(), X},
	
	receive
		Received ->
			Received
	end.

bank(Balance) ->
    receive
	{From, {add, Y}} ->
	    From ! ok,
	    bank(Balance+Y);
	{From, {withdraw, Y}} when (Balance - Y) < 0->
		From ! insufficient_funds,
		bank(Balance);
	{From, {withdraw, Y}} ->
		From ! ok,
		bank(Balance -Y);
	{From, {balance}} ->
	    From ! Balance,
		bank(Balance)
    end.