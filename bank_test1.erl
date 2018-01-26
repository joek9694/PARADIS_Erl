-module(bank_test1).
-compile(export_all).

test() ->
%%    Pid = new(),
%%    ok = add(Pid, 10),
%%    ok = add(Pid, 20),
%%    30 = balance(Pid),
%%    ok = withdraw(Pid, 15),
%%    15 = balance(Pid),
%%    insufficient_funds = widthdraw(Pid, 20),
    horray.

new() ->
    spawn(fun() -> bank(0) end).
	
balance(Pid) ->
    %% return the balance of the account
									%% TEST
	case Pid of
		{bank_test1, X} ->
			X
	end.

add(Pid, X) -> rpc(Pid, implement_this).

withdraw(Pid, X) ->
    implement_this.

rpc(Pid, X) ->
    implement_this.

bank(X) ->
    receive
	{From, {add, Y}} ->
	    From ! ok,
	    bank(X+Y);
	{From, {withdraw, Y}} ->
		implement_this;
	{X ,{bank_test1, 0}} ->			%%TEST
		{bank_test1, X +0}
    end.