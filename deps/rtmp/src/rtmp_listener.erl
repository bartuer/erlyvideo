%%% @private
%%% @author     Max Lapshin <max@maxidoors.ru> [http://erlyvideo.org]
%%% @copyright  2010 Max Lapshin
%%% @doc        RTMP listener
%%% @reference  See <a href="http://erlyvideo.org/rtmp" target="_top">http://erlyvideo.org/rtmp</a> for more information
%%% @end
%%%
%%% This file is part of erlang-rtmp.
%%% 
%%% erlang-rtmp is free software: you can redistribute it and/or modify
%%% it under the terms of the GNU General Public License as published by
%%% the Free Software Foundation, either version 3 of the License, or
%%% (at your option) any later version.
%%%
%%% erlang-rtmp is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%% GNU General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with erlang-rtmp.  If not, see <http://www.gnu.org/licenses/>.
%%%
%%%---------------------------------------------------------------------------------------
-module(rtmp_listener).
-author('Max Lapshin <max@maxidoors.ru>').

%% External API
-export([start_link/3]).
-export([accept/2]).



%%--------------------------------------------------------------------
%% @spec (Port::any(), Name::atom(), Callback::atom()) -> {ok, Pid} | {error, Reason}
%%
%% @doc Called by a supervisor to start the listening process.
%% @end
%%----------------------------------------------------------------------
start_link(Port, Name, Callback) ->
  gen_listener:start_link(Name, Port, ?MODULE, [Callback]).


accept(CliSocket, [Callback]) ->
  {ok, RTMP} = rtmp_sup:start_rtmp_socket(accept),
  gen_tcp:controlling_process(CliSocket, RTMP),
  {ok, Pid} = Callback:create_client(RTMP),
  rtmp_socket:setopts(RTMP, [{consumer, Pid}]),
  rtmp_socket:set_socket(RTMP, CliSocket),
  ok.



