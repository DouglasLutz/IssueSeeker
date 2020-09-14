defmodule IssueSeekerWeb.AuthController do
  use IssueSeekerWeb, :controller
  alias IssueSeeker.Accounts

  plug(Ueberauth)

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      email: auth.info.email,
      nickname: auth.info.nickname,
      token: auth.credentials.token,
      name: auth.info.name,
      image: auth.info.image,
      description: auth.info.description,
      bio: auth.extra.raw_info.user["bio"],
      location: auth.info.location
    }

    signin(conn, user_params)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp signin(conn, user_params) do
    case Accounts.create_or_update_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
