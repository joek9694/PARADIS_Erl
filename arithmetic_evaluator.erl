-module(arithmetic_evaluator).

-compile(export_all).

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
	
eval([H|T]) when is_atom(H) ->
	eval(list_to_tuple([H|T]));
	
eval(E) when is_list(E) ->
	[H1, H2|T] = E,
	eval(T ++ [eval(H2)] ++[eval(H1)]).
	
