defmodule IssueSeekerWeb.UserController do
  use IssueSeekerWeb, :controller

  def profile(conn, _) do
    user = current_user(conn)
    text(conn, "#{inspect(user)}")
  end
end
