defmodule IssueSeeker.Profiles.Profile do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import IssueSeeker.Helpers.Changeset

  alias __MODULE__
  alias IssueSeeker.{Repo, Profiles}
  alias IssueSeeker.Accounts.User
  alias IssueSeeker.Profiles.{Level, Language}

  schema "profiles" do
    belongs_to :user, User, on_replace: :update
    belongs_to :level, Level, on_replace: :nilify
    many_to_many :languages, Language, join_through: "profiles_languages", on_replace: :delete

    timestamps()
  end

  def changeset(profile \\ %Profile{}, attrs) do
    languages =
      attrs
      |> Map.get("languages", [])
      |> Profiles.filter_languages_by_id()

    level =
      attrs
      |> Map.get("level", "")
      |> Profiles.get_level_by_name()

    profile
    |> Repo.preload([:user, :level, :languages])
    |> cast(attrs, [])
    |> put_existing_assoc(:user, Map.get(attrs, "user"))
    |> put_existing_assoc(:level, level)
    |> put_assoc(:languages, languages)
    |> validate_required([:user])
  end
end
