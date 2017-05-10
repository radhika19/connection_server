defmodule SocketServer do
  @moduledoc """
   uses :gen_tcp to read http requests
  """

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [active: false, reuseaddr: true])
    acceptor(socket)
  end

  def acceptor(socket) do
    {:ok, request} = :gen_tcp.accept(socket)
    pid = spawn(fn -> serve(request) end)
    :ok = :gen_tcp.controlling_process(request, pid)
    acceptor(socket)
  end

  def serve(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    process_request(data, socket)
  end

  defp process_request(data, socket) do
    method = data
      |> :erlang.list_to_bitstring()
      |> String.split(" ")
      |> hd()
      |> String.downcase()
      |> String.to_atom()
    response = apply(HTTPRequest, method, [:erlang.list_to_bitstring(data)])
    res_par = response
      |> parse_response()
      |> :erlang.bitstring_to_list()
    :gen_tcp.send(socket, res_par)
  end

  defp parse_response({:ok, res}) do
    res_p = Poison.encode!(res)
    "HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: application/json\r\n\r\n#{res_p}\r\n\r\n"
  end

  defp parse_response({:error, _e}) do
    "HTTP/1.1 404 NOT FOUND\r\n\r\n\r\n\r\n\r\n\r\n"
  end
end
