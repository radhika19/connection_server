defmodule ConnTime do
  @moduledoc """
    sets pid, ref and connid in ETS for retrieval
  """

  def add_connid(connid, time, pid) do
    spawn(ConnTime, :add_conn, [connid, time, pid])
  end

  def add_conn(connid, time, pid) do
    timer_ref = Process.send_after(pid, :timeout, time)
    ETS.add(connid, pid, timer_ref)
  end

  def get_connid(connid) do
    ETS.lookup(connid)
  end

  def get_all_connid do
    ETS.lookup_all()
  end
end
