defmodule Meshi.PageController do
  use Meshi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
