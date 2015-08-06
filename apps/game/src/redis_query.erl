-module(redis_query).
-define(REDIS_POOL, redis_pool).
-define(TIMEOUT, 5000).

-export([
         get/1,
         set/2,
         expire/2,
         delete/1
        ]).

%% query
q(Command) ->
    q(Command, ?TIMEOUT).

q(Command, Timeout) ->
    lager:info("redis_query q Command = ~s~n", [Command]),
    poolboy:transaction(?REDIS_POOL, fun(Worker) ->
                                             gen_server:call(Worker, {q, Command, Timeout})
                                     end).

%% query pipeline
qp(Command) ->
    qp(Command, ?TIMEOUT).

qp(Command, Timeout) ->
    poolboy:transaction(?REDIS_POOL, fun(Worker) ->
                                             gen_server:call(Worker, {qp, Command, Timeout})
                                     end).

get(Key) -> 
    q(["GET", Key]).

set(Key, Value) -> 
    q(["SET", Key, Value]).

expire(Key, Time) -> 
    q(["EXPIRE", Key, Time]).

delete(Key) -> 
    q(["DEL", Key]).
