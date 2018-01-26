-module(multi_bank).

%
% Running test() should return hooray.
%

-import(maps, [put/3, remove/2 ,is_key/2, get/2]).
%-compile(export_all).
-export([test_regular_bank/0, new/0, add_account/2, remove_account/2, balance/2, add/3, withdraw/3, lend/4]).


%%-------------- module tests.
test_regular_bank() ->
    Pid = new(),
	ok = add_account(Pid, pelle),
	{'EXIT', _} = (catch add_account(Pid, "pelle2")),
	ok = add_account(Pid, pelle2),
	ok = add_account(Pid, pelle3),
    ok = add(Pid, pelle, 10),
	ok = add(Pid, pelle2, 10),
    ok = add(Pid, pelle, 20),
    30 = balance(Pid, pelle),
    ok = withdraw(Pid, pelle, 15),
    15 = balance(Pid, pelle),
    insufficient_funds = withdraw(Pid, pelle, 20),
	ok = lend(Pid, pelle, pelle2, 15),
	0 = balance(Pid, pelle),
	25 = balance(Pid, pelle2),
	insufficient_funds = lend(Pid, pelle, pelle2, 15),
	not_ok = lend(Pid, pelle, pelle2, "wrong value"),
    hooray.

	
%%-------------- module.
	
%% Start a new process in which an infinite loop of recursive calls to bank/1
%% holds the balance for your bank account.
new() ->
	Accounts = maps:new(),
    spawn(fun() -> multi_bank(Accounts) end).
	
add_account(Pid, Who) when is_atom(Who)->
	rpc(Pid, Who, {add_account}).
	

remove_account(Pid, Who) ->
	rpc(Pid, Who, {remove_account}).
	
	
	
%% Checks the balance for the bank account in process Pid.
%% Returns the balance when succesful.
balance(Pid, Who) ->
    rpc(Pid, Who, {balance}).
	

%% Adds X to the current balance of bank account in process Pid. 
%% Returns ok when succesful.
add(Pid, Who, X) -> 
	rpc(Pid, Who,{add, X}).

	
%% Withdraws X from the current balance of bank account in process Pid.
%% Returns ok when succesful.	
withdraw(Pid, Who ,X) ->
	rpc(Pid, Who, {withdraw, X}).
	
	

	
lend(Pid, From, To, Amount) ->
	rpc(Pid, From, To, {lend, Amount}).

	
%% Acts as a middle man between the recursively stateful bank account in bank/1
%% and the function calls within this module.
%% Sends it's second argument as a message to it's specified first argument,
%% and awaits a reply. The response is returned. 
rpc(Pid, Who, X) ->
    Pid ! {self(), Who, X},
	
	receive
		Received ->
			Received
	end.
	
rpc(Pid, From, To, X) ->
    Pid ! {self(), From, To, X},
	
	receive
		Received ->
			Received
	end.

%%	Main recursive function of this module, where the state of the 
%%  bank account is held. 
%%  Answers received message and recursively calls itself with updated state.
	
multi_bank(Account_Map) ->
    receive
	{From, Who, {add_account}} ->
		Is_Key = maps:is_key(Who, Account_Map),
		if	
			Is_Key =:= false -> 
				From ! ok,
				New_Account = maps:put(Who, 0, Account_Map),
				multi_bank(New_Account);
			true ->
				From ! not_ok
		end;
		
	{From, Who, {remove_account}} ->
		Is_Key = maps:is_key(Who, Account_Map),
		if 
			Is_Key =:= true ->
				From ! ok,
				Map_Without_Account = maps:remove(Who, Account_Map),
				multi_bank(Map_Without_Account);
			true ->
				From ! not_ok
		end;
		
	{From, Who,{add, Y}} ->
		Is_Key = maps:is_key(Who, Account_Map),
		if
			Is_Key =:= true ->
				From ! ok,
				Account = maps:get(Who, Account_Map),
				New_Map = maps:put(Who ,Account + Y, Account_Map),
				multi_bank(New_Map);
			true ->
				From ! not_ok
		end;
		
	{From, Who,{withdraw, Y}} ->
	Value = maps:get(Who, Account_Map, -1),
		if  
			(Value - Y) < 0 ->
				From ! insufficient_funds,
				multi_bank(Account_Map);
			(Value - Y) >= 0 ->
				From ! ok,
				%Account = maps:get(Who,Account_Map),
				multi_bank(maps:put(Who ,Value - Y, Account_Map));
			true ->
				From ! not_ok
		end;
		
	{From, Who, To, {lend, Amount}} ->
		Who_Is_Key = maps:is_key(Who, Account_Map),
		To_Is_Key = maps:is_key(Who, Account_Map),
		Value = maps:get(Who, Account_Map, -1),
		if
			Who_Is_Key =:= true , To_Is_Key =:= true ->
			
			if  
				(Value - Amount) < 0 ->
					From ! insufficient_funds,
					multi_bank(Account_Map);
				(Value - Amount) >= 0 ->
					From ! ok,
					ToVal = maps:get(To, Account_Map),
					Map_update = maps:put(Who, Value - Amount, Account_Map),
					Map_update2 = maps:put(To , ToVal + Amount, Map_update),
					multi_bank(Map_update2);
				true ->
					From ! not_ok
			end;
			
			true ->
					From ! not_ok
		end;
	{From, Who, {balance}} ->
	Is_Key = maps:is_key(Who, Account_Map),
		if
			Is_Key =:= true ->
				Account = maps:get(Who,Account_Map),
				From ! Account,
				multi_bank(Account_Map);
			true ->
				From ! not_ok
		end
	
    end.