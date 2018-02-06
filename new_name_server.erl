-module(new_name_server).
-export([init/0, add/2, all_names/0, delete/1, find/1, handle/2]).
-import(server3, [rpc/2]).

