-module(one_time_storage_app).
-behaviour(application).
-export([start/2]).
-export([stop/1]).

start_protocol_scheme(<<"https">>, Dispatch) ->
    PrivDir = code:priv_dir(one_time_storage),
    {ok, _} = cowboy:start_https(https,
                                 100,
                                 [{port, one_time_storage_config:port()},
                                  {cacertfile, PrivDir ++ "/ssl/server.crt"},
                                  {certfile, PrivDir ++ "/ssl/server.crt"},
                                  {keyfile, PrivDir ++ "/ssl/server.key"}],
                                 [{env, [{dispatch, Dispatch}]}]);
start_protocol_scheme(<<"http">>, Dispatch) ->
    {ok, _} = cowboy:start_http(http,
                                100,
                                [{port, one_time_storage_config:port()}],
                                [{env, [{dispatch, Dispatch}]}]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([{one_time_storage_config:hostname(),
                                       [{"/read/[:filename]", read_handler, []},
                                        {"/write/[:filename]", write_handler, []}]}]),
    start_protocol_scheme(one_time_storage_config:protocol_scheme(), Dispatch),
    one_time_storage_sup:start_link().

stop(_State) ->
    ok.
