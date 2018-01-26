-module(multi_bank).

% By: JoEk9694, Johan Eklundh
% 
% Running test() should return hooray.
%

-import(maps, [put/3, remove/2 ,is_key/2, get/2]).
-export([test_multi_bank/0, new/0, add_account/2, remove_account/2, balance/2, add/3, withdraw/3, lend/4]).


%%-------------- module tests.
test_multi_bank() ->
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
	
%% Start a new process in which an infinite loop of recursive calls to multi_bank/1
%% holds the map in which the balance for different accounts are mapped as value and the name for an account is its name.
new() ->
	Accounts = maps:new(),
    spawn(fun() -> multi_bank(Accounts) end).
	

%%Add a new account to the map of accounts, given that the atom(second argument) which represents the new account name 
%% is actually an atom. First argument is the process in which the account is to be added.
%% Returns ok if new account is added, not_ok otherwise.
add_account(Pid, Who) when is_atom(Who)->
	rpc(Pid, {Who, add_account}).
	

%% First argument represents the process in which to remove given account.
%% Second argument represents the name(atom) of the account to be removed. Returns ok if account is removed, not_ok otherwise.
remove_account(Pid, Who) ->
	rpc(Pid, {Who, remove_account}).
	
	
%% Checks the balance for account specified by second argument in process Pid.			
%% Returns the balance when succesful, not_ok otherwise.
balance(Pid, Who) ->
    rpc(Pid, {Who, balance}).
	

%% Adds X to the current balance of bank account specified by second argument(Who) in process specified by first argument(Pid). 
%% Returns ok if succesful, not_ok otherwise.
add(Pid, Who, X) -> 
	rpc(Pid, {Who, add, X}).

	
%% Withdraws X from the current balance of bank account specified by second argument(Who) in process specified by first argument(Pid).
%% Returns 'ok' if succesful. Returns 'insufficient_funds' if current balance is less than amount to be withdrawn. Returns not_ok otherwise.	
withdraw(Pid, Who ,X) ->
	rpc(Pid, {Who, withdraw, X}).
	
	
%% Withdraws Amount(fourth argument) from From (second argument), and adds Amount (fourth argument) to To (third argument) given that
%% the process Pid(first argument) contains From(second argument) and To(third) as keys in Account_Map and that From has sufficient funds.
%% Returns 'ok' if succesful. Returns 'insufficient_funds' if From(second argument)s current balance is less than amount to be withdrawn.
%% Returns 'not_ok' otherwise.
lend(Pid, From, To, Amount) ->
	rpc(Pid, {From, To, lend, Amount}).

	
%% Sends it's second argument as a message to it's specified first argument,
%% and awaits a reply. The response is returned.
rpc(Pid, X) ->
    Pid ! {self(), X},
	
	receive
		Received ->
			Received
	end.

%%	Main recursive function of this module, where the state of the 
%%  accounts is held. 
%%  Answers received message and recursively calls itself with updated state.
	
multi_bank(Account_Map) ->
    receive
	{From, {Who, add_account}} ->
		Key = maps:is_key(Who, Account_Map),
		if	
			Key =:= false -> 
				From ! ok,
				Map_With_New_Account = maps:put(Who, 0, Account_Map),
				multi_bank(Map_With_New_Account);
			true ->
				From ! not_ok
		end;
		
	{From, {Who, remove_account}} ->
		Key = maps:is_key(Who, Account_Map),
		if 
			Key =:= true ->
				From ! ok,
				Map_Without_Account = maps:remove(Who, Account_Map),
				multi_bank(Map_Without_Account);
			true ->
				From ! not_ok
		end;
		
	{From, {Who, add, Y}} ->
		Key = maps:is_key(Who, Account_Map),
		if
			Key =:= false ->
				From ! not_ok;
			true ->
				From ! ok,
				Account = maps:get(Who, Account_Map),
				New_Map = maps:put(Who ,Account + Y, Account_Map),
				multi_bank(New_Map)	
		end;
		
	{From, {Who, withdraw, Y}} ->
	Value = maps:get(Who, Account_Map, -1),
		if  
			(Value - Y) < 0 ->
				From ! insufficient_funds,
				multi_bank(Account_Map);
			(Value - Y) >= 0 ->
				From ! ok,
				multi_bank(maps:put(Who ,Value - Y, Account_Map));
			true ->
				From ! not_ok
		end;
		
	{From, {Who, To, lend, Amount}} ->
		Who_Is_Key = maps:is_key(Who, Account_Map),
		To_Is_Key = maps:is_key(To, Account_Map),
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
		
	{From, {Who, balance}} ->
	Key = maps:is_key(Who, Account_Map),
		if
			Key =:= true ->
				Account = maps:get(Who,Account_Map),
				From ! Account,
				multi_bank(Account_Map);
			true ->
				From ! not_ok
		end
	
    end.