defmodule IssueSeekerWeb.ProfileController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Profiles.Profile
  alias IssueSeeker.Profiles

  def new(conn, _) do
    case current_user_profile(conn) do
      %Profile{} = profile ->
        changeset = Profiles.change_profile(profile)
        render(conn, "edit.html", changeset: changeset)
      _ ->
        changeset = Profiles.change_profile(%Profile{}, %{})
        render(conn, "new.html", changeset: changeset)
    end
    # render(conn, "new.html",  user: user)
  end

  def create(conn, %{"profile" => profile_params}) do
    profile_params = Map.merge(profile_params, %{"user" => current_user(conn)})
    case Profiles.create_profile(profile_params) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile created successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    case current_user_profile(conn) do
      %Profile{} = profile ->
        changeset = Profiles.change_profile(profile)
        render(conn, "edit.html", changeset: changeset)
      _ ->
        changeset = Profiles.change_profile(%Profile{}, %{})
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"profile" => profile_params}) do
    profile = current_user_profile(conn)
    case Profiles.update_profile(profile, profile_params) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    profile = current_user_profile(conn)
    render(conn, "show.html", profile: profile)
  end
end
