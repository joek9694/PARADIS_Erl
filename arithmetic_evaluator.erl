-module(arithmetic_evaluator).
%% By: Johan Eklundh, joek9694
%%
%% Run all_tests() to go through all tests.

-export([eval/1, safe_eval/1, eval_process/0, all_tests/0,
	test_eval_process/1, test_safe_eval/0 ,test_eval/0, test_eval_divide/0,
	test_eval_times/0, test_eval_plus/0, test_eval_minus/0 ]).

%----------------Tests----------------------------

%% Runs all tests. Returns 'hooray' if succesful.
all_tests() ->
	test_eval(),
	test_safe_eval(),
	test_eval_process({plus, 1, 1}),
	test_eval_process(1),
	test_eval_process({plus, "wrong-input" , 1}),
	test_eval_process({1, 1 , 1}),
	test_eval_process({plus, 1 , plus}),
	test_eval_process({times , {plus, 1 , 1} , {plus, 1 , 1}}),
	test_eval_process({times , 2 ,{times , {plus, 1 , 1} , {plus, 1 , 1}}}),
	test_eval_process({}),
	test_eval_process(wrong_input),
	test_eval_process({1, 1 , 1}),
	hooray.

%---------------Tests for eval()------------------

%% Runs all tests for eval().
test_eval() ->
	test_eval_divide(),
	test_eval_times(),
	test_eval_plus(),
	test_eval_minus().

test_eval_divide() ->
	{'EXIT',_} = (catch eval({divide, 1, 0})),
	eval({divide, 1,1}),
	eval({divide, 1,2}),
	eval({divide, 1,3}),
	eval({divide, 1,-3}),			
	eval({divide, 1,-2}),
	eval({divide, 1,-1}),
	
	eval({divide, 1, 1}),
	eval({divide, 2, 1}),
	eval({divide, 3, 1}),
	eval({divide, -3, 1}),			
	eval({divide, -2, 1}),
	eval({divide, -1, 1}).

test_eval_times() ->
	eval({times, 0,0}),
	eval({times, 0,-0}),
	eval({times, -0,0}),
	eval({times, 1,0}),
	eval({times, 0,1}),
	eval({times, 1, 0.5}),
	eval({times, 0.5, 1}),
	eval({times, 1, -0.5}),
	eval({times, -0.5, 1}),
	eval({times, 1,1}),

	eval({times, 1,1.5}),
	eval({times, 1.5,1}),
	eval({times, 2,1}),
	eval({times, 1,2}).

test_eval_plus() ->
	eval({plus, 0, 0}),
	eval({plus, 0, -0}),
	eval({plus, -0, 0}),
	eval({plus, -0, -0}),
	eval({plus, 0, 1}),
	eval({plus, 1, 0}),
	eval({plus, 0, -1}),
	eval({plus, -1, 0}),
	eval({plus, -1, -1}),
	eval({plus, 1, 1}),

	eval({plus, 1, 2}),
	eval({plus, -1, 2}),
	eval({plus, 1, -2}),
	eval({plus, -1, -2}).

test_eval_minus() ->
	eval({minus, 0, 0}),
	eval({minus, -0, -0}),
	eval({minus, 0, -0}),
	eval({minus, -0, 0}),
	eval({minus, 0, 1}),
	eval({minus, 1, 0}),
	eval({minus, 1, 1}),

	eval({minus, 0.5, 1}),
	eval({minus, 1, 0.5}),

	eval({minus, -0.5, 1}),
	eval({minus, 1, -0.5}),

	eval({minus, 0.5, -1}),
	eval({minus, -1, 0.5}),

	eval({minus, -0.5, -1}),
	eval({minus, -1, -0.5}),

	eval({minus, 5, 2}),
	eval({minus, 2, 5}).


%---------------Tests for safe_eval()-------------
%% Tests the try and the catch of the safe_eval funktion.
test_safe_eval() ->
	safe_eval({divide, 1, 0}),
	safe_eval({divide, 1, 1}).

%------------Test for eval_process()--------------

%% Takes as argument the arithmetic expression that are to be evaluated.
%% Returns the reply(in the form: {ok, Arithmetic_Evaluation}) if succesful
%% within 1 sec. If unsuccesful, an error message (in the form: {error, Stack_Trace})
%% for all types of errors. Otherwise returns 'no_reply'.
test_eval_process(F) ->
	Pid2 = eval_process(),
	Pid2 ! {self(), F},
	receive
			Rep -> Rep
		after 1000 -> 
			no_reply
	end.


%---------------------eval-----------------------

%% Returns the value of the arithmetic evaluation.
%% Throws exception error if no clause matches.
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
	
eval({X,A,B}) when is_atom(X)->
	NewB = eval(B),
	NewA = eval(A),
	eval({X, NewA, NewB}).

%%-------------------safe_eval-------------------

%% Returns the value of the arithmetic evaluation in the form {ok, Val}
%% if succesful. Otherwise returns stacktrace of error in the form 
%% {error, StackTrace}

safe_eval(X)->
	try 
		Val = eval(X),
		{ok, Val}
	catch
		_:_->
		{error, erlang:get_stacktrace()}
	end.

%%-----------------eval_process-------------------
%% Spawns a new process that waits for a message containing a sender-Pid.
%% Returns a message to the specified sender
%% containing an evaluation of the arithmetics 
%% or an error message (see: safe_eval/1). Any message received that 
%% does not match the pattern is overlooked, no response is sent. 
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







