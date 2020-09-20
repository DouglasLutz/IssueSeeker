defmodule IssueSeeker.Profiles do
  import Ecto.Query
  alias IssueSeeker.Repo
  alias IssueSeeker.Profiles.{Language, Level, Profile}

  def filter_languages_by_name(languages_names) do
    query = from l in Language, where: l.name in ^languages_names
    Repo.all(query)
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
    |> Repo.insert()
  end
end
