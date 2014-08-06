-module(read_handler).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

not_found_no_file({error, noent}, Req, _Filename) ->
    cowboy_req:reply(404, Req);
not_found_no_file({ok, Bin}, Req, Filename) ->
    ok = file:delete(Filename),
    cowboy_req:reply(200, [], Bin, Req).

reject_except_get(<<"GET">>, Req) ->
    {Filename, Req2} = cowboy_req:binding(filename, Req),
    Filename2 = filename:join(one_time_storage_config:path(),
                              filename:basename(binary_to_list(Filename))),
    {Status, Data} = file:read_file(Filename2),
    not_found_no_file({Status, Data}, Req2, Filename2);
reject_except_get(_, Req) ->
    cowboy_req:reply(405, Req).

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req),
    {ok, Req3} = reject_except_get(Method, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
