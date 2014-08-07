-module(write_handler).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

reject_except_put(<<"PUT">>, Req) ->
    {Filename, Req2} = cowboy_req:binding(filename, Req),
    Filename2 = filename:join(one_time_storage_config:path(),
                              filename:basename(binary_to_list(Filename))),
    {ok, IoDevice} = file:open(Filename2, [write, raw]),
    Decoder = fun(Data) ->
            ok = file:write(IoDevice, Data),
            {ok, Data}
    end,
    {ok, _Body, Req3} = cowboy_req:body(Req2, [{content_decode, Decoder}]),
    ok = file:close(IoDevice),
    cowboy_req:reply(200, [], <<"writed.">>, Req3);
reject_except_put(_, Req) ->
    cowboy_req:reply(405, Req).

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req),
    {ok, Req3} = reject_except_put(Method, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
