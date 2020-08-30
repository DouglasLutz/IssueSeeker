defmodule IssueSeekerWeb.PageController do
  use IssueSeekerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
