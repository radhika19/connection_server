defmodule ETS do
  @moduledoc """
    this module is used to save and retrieve connids, ref and pid in erlang term storage(ETS)
    under the table - `process_directory`
  """

  def add(connid, pid, timer_ref) do
    :ets.insert(:process_directory, {connid, {pid, timer_ref}})
  end

  def lookup(connid) do
    :ets.lookup(:process_directory, connid)
  end

  def lookup_all do
    :ets.match(:process_directory, :"$1")
  end

  def delete(connid) do
    :ets.delete(:process_directory, connid)
  end
end
