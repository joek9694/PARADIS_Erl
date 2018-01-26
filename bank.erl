-module(bank).

%
% Running test() should return hooray.
%

-compile(export_all).


%%-------------- module tests.
test() ->
    Pid = new(),
    ok = add(Pid, 10),
    ok = add(Pid, 20),
    30 = balance(Pid),
    ok = withdraw(Pid, 15),
    15 = balance(Pid),
    insufficient_funds = withdraw(Pid, 20),
    hooray.

	
%%-------------- module.
	
%% Start a new process in which an infinite loop of recursive calls to bank/1
%% holds the balance for your bank account.
new() ->
    spawn(fun() -> bank(0) end).
	
	
%% Checks the balance for the bank account in process Pid.
%% Returns the balance when succesful.
balance(Pid) ->
    rpc(Pid, {balance}).
	

%% Adds X to the current balance of bank account in process Pid. 
%% Returns ok when succesful.
add(Pid, X) -> 
	rpc(Pid, {add, X}).

	
%% Withdraws X from the current balance of bank account in process Pid.
%% Returns ok when succesful.	
withdraw(Pid, X) ->
	rpc(Pid, {withdraw, X}).

	
%% Acts as a middle man between the recursively stateful bank account in bank/1
%% and the function calls within this module.
%% Sends it's second argument as a message to it's specified first argument,
%% and awaits a reply. The response is returned. 
rpc(Pid, X) ->
    Pid ! {self(), X},
	
	receive
		Received ->
			Received
	end.

%%	Main recursive function of this module, where the state of the 
%%  bank account is held. 
%%  Answers received message and recursively calls itself with updated state.
	
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