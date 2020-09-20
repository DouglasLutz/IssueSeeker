defmodule IssueSeeker.Profiles.Profile do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias IssueSeeker.{Accounts, Profiles}
  alias IssueSeeker.Accounts.User
  alias IssueSeeker.Profiles.{Level, Language}

  schema "profiles" do
    belongs_to :user, User
    belongs_to :level, Level
    many_to_many :languages, Language, join_through: "profiles_languages"

    timestamps()
  end

  def changeset(profile \\ %Profile{}, attrs) do
    languages =
      attrs
      |> Map.get("languages")
      |> Profiles.filter_languages_by_name()

    level =
      attrs
      |> Map.get("level")
      |> Profiles.get_level_by_name()

    user =
      attrs
      |> Map.get("user_id")
      |> Accounts.get_user()

    profile
    |> cast(attrs, [])
    |> put_assoc(:user, user)
    |> put_assoc(:level, level)
    |> put_assoc(:languages, languages)
  end
end
