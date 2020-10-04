defmodule IssueSeekerWeb.Plugs.Authorize do
  @moduledoc """
  A simple plug to prevent users without correct permissions from continuing
  """

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn

  def init(opts), do: opts

  def call(%{assigns: %{current_user: %{profile: %{}}}} = conn, has_profile: true), do: conn
  def call(%{assigns: %{current_user: %{profile: nil}}} = conn, has_profile: true) do
    conn
    |> put_status(401)
    |> put_flash(:error, "You must have a profile created")
    |> redirect(to: "/")
  end

  def call(%{assigns: %{current_user: %{admin: true}}} = conn, admin: true), do: conn
  def call(%{assigns: %{current_user: %{}}} = conn, []), do: conn
  def call(conn, _opts) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Insufficient permissions")
    |> redirect(to: "/")
  end
end
