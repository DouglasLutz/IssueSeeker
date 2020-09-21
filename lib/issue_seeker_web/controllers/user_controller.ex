defmodule IssueSeekerWeb.UserController do
  use IssueSeekerWeb, :controller

  def self(conn, _) do
    user = current_user(conn)
    render(conn, "show.html",  user: user)
  end
end
