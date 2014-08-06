-module(one_time_storage_config).
-export([hostname/0,
         port/0,
         disable_https/0,
         protocol_scheme/0,
         path/0]).

get_from_env(Key) ->
    {ok, Val} = application:get_env(one_time_storage, Key),
    Val.

hostname() ->
    get_from_env(hostname).

port() ->
    get_from_env(port).

disable_https() ->
    get_from_env(disable_https).

protocol_scheme() ->
    case disable_https() of
        true ->
            <<"http">>;
        _ ->
            <<"https">>
    end.

path() ->
    filename:join(code:priv_dir(one_time_storage),
                  "pub").
