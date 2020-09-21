defmodule IssueSeeker.Profiles do
  import Ecto.Query
  alias IssueSeeker.Repo
  alias IssueSeeker.Accounts.User
  alias IssueSeeker.Profiles.{Language, Level, Profile}

  def list_languages() do
    Repo.all(from l in Language, order_by: l.name)
  end

  def filter_languages_by_name(languages_names) do
    query = from l in Language, where: l.name in ^languages_names
    Repo.all(query)
  end

  def filter_languages_by_id(languages_ids) do
    query = from l in Language, where: l.id in ^languages_ids
    Repo.all(query)
  end

  def list_levels() do
    Repo.all(Level)
  end

  def get_level_by_name(level_name) do
    Repo.get_by(Level, %{name: level_name})
  end

  def create_profile(profile_params) do
    %Profile{}
    |> Profile.changeset(profile_params)
    |> Repo.insert()
  end

  def update_profile(profile, profile_params) do
    profile
    |> Profile.changeset(profile_params)
    |> Repo.update()
  end

  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  def get_user_profile(%User{} = user) do
    user
    |> Ecto.assoc(:profile)
    |> Repo.one()
    |> Repo.preload([:user, :level, :languages])
  end
  def get_user_profile(_), do: nil
end
