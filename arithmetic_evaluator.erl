-module(arithmetic_evaluator).

-compile(export_all).

%-----------------eval-----------------
eval(X) when is_number(X) ->
	X;
	 
eval({plus, A, B}) when is_number(A),is_number(B)->
	A + B;
eval({minus, A, B}) when is_number(A),is_number(B)->
	A - B;
eval({times, A, B}) when is_number(A),is_number(B)->
	A * B;
eval({divide, A, B}) when is_number(A),is_number(B)->
	A / B;
	
eval(E) when is_tuple(E) , tuple_size(E) > 2 -> 
	eval(lists:reverse(tuple_to_list(E)));
	
eval([H1, H2, H3|T]) when is_atom(H1), is_number(H2), is_number(H3) ->
	eval(list_to_tuple([H1|T]));
	
eval(E) when is_list(E) ->
	[H1, H2|T] = E,
	eval(T ++ [eval(H2)] ++[eval(H1)]).

%%----------------safe_eval-----------------
	
safe_eval(X)->
	try 
		Val = eval(X),
		{ok, Val}
	catch
		_:_->
		{error, erlang:get_stacktrace()}
	end.

%%-----------------process-------------------

eval_process() ->

	Pid = spawn(fun receiver/0).

receiver()	->
	
	receive
		{From, E} when is_pid(From)->
			From ! safe_eval(E),
			receiver();
		_ ->
			receiver()
	end.

test(F) ->
	Pid2 = eval_process(),
	Pid2 ! {self(), F},
	receive
			Rep -> Rep
		after 1000 -> 
			no_reply
	end.






