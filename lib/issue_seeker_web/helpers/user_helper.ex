defmodule IssueSeekerWeb.UserHelper do
  @moduledoc false

  def admin_session?(conn) do
    case current_user(conn) do
      %{admin: true} -> true
      _ -> false
    end
  end

  def signed_in?(conn), do: current_user(conn) != nil

  def has_created_profile?(conn), do: current_user_profile(conn) != nil

  def current_user(%{assigns: %Phoenix.LiveView.Socket.AssignsNotInSocket{}}), do: nil

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def current_user_profile(conn) do
    conn
    |> current_user()
    |> IssueSeeker.Profiles.get_user_profile()
  end
end
