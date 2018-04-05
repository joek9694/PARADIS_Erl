-module(try_out).

-export([area/1, perimeter/1]).

area({square,X}) -> X*X;
area({rectangle, X,Y}) -> X * Y;
area({rectangle2, X,Y}) -> io:format("~p~n", [X * Y]);
area({rectangle3, X,Y}) -> io:format("~p~n", [X * Y]), hooray.

perimeter({square, X}) -> X * 4;
perimeter({square2, X}) -> Y = square, io:format("~p~n",[X * 4]), Y.


