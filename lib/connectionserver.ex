defmodule Connectionserver do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      worker(Task, [SocketServer, :accept, [8080]]),
      supervisor(Connectionserver.Endpoint, []),
    ]

    :ets.new(:process_directory, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Connectionserver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Connectionserver.Endpoint.config_change(changed, removed)
    :ok
  end
end
