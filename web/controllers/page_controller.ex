defmodule Connectionserver.PageController do
  use Connectionserver.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
