defmodule IssueSeeker.Accounts do
  alias IssueSeeker.{Repo, Accounts.User}

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(user, user_params) do
    user
    |> User.changeset(user_params)
    |> Repo.update()
  end

  def create_or_update_user(user_params) do
    case get_user_by(email: Map.get(user_params, :email)) do
      %User{} = user ->
        update_user(user, user_params)
      nil ->
        create_user(user_params)
    end
  end

end
