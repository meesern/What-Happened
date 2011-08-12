
-module (mod_bridge).

-behaviour (gen_mod).

-include("ejabberd.hrl").

-export([start/2, stop/1]).

start(_Host, _Opts) ->
  ?INFO_MSG("mod_bridge starting", []),
  ok.

stop(_Host) ->
  ?INFO_MSG("mod_bridge stopping", []),
  ok.


