defmodule HTTPRequest do
  @moduledoc """
    parses the http request from the data received.
    GET and PUT have been implemented.
  """

  def get(data) do
    url = get_url(data)
    get_details(url, data)
  end

  def put(data) do
    url = get_url(data)
    put_details(url, data)
  end

  defp get_url(data) do
    data
      |> String.split(" ")
      |> Enum.at(1)
  end

  defp put_details("/api/kill", data) do
    json_request = data
      |> String.split("\r\n")
      |> List.last()
      |> Poison.decode!
    connid = json_request["connId"]
    connid = "#{connid}"
    with [{_connid, {pid, _ref}}] <- ETS.lookup(connid),
      :kill <- send(pid, :kill)
    do
      {:ok, %{"status" => "killed"}}
    else
      [] -> {:ok, %{"status" => "invalid connection Id : #{connid}"}}
      _ -> {:error, "Error in killing process"}
    end
  end

  defp get_details("/api/request?" <> params, _data) do
    try do
      ["connId=" <> connid, timeout] = String.split(params, "&timeout=")
      timeout = String.to_integer(timeout) * 1000
      pid = self()
      spawn &HTTPRequest.receive_task/0
      Task.async(ConnTime, :add_connid, [connid, timeout, pid])
      receive_task()
      ETS.delete(connid)
      {:ok, %{"status" => "ok"}}
    rescue
      e in _ -> {:error, e}
    end
  end

  defp get_details("/api/serverStatus", _data) do
    all_connids = ETS.lookup_all()
      |> List.flatten
    all_conn_data = Enum.reduce(all_connids, %{}, fn({id, {_pid, ref}}, acc) ->
      Map.put(acc, id, Process.read_timer(ref)/1000)
    end)
    {:ok, all_conn_data}
  end

  def receive_task do
    receive do
      :kill ->
        :kill
      :timeout ->
        :timeout
    end
  end
end
