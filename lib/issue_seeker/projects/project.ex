defmodule IssueSeeker.Projects.Project do
  use Ecto.Schema

  import Ecto.Changeset
  import IssueSeeker.Helpers.Changeset

  alias __MODULE__
  alias IssueSeeker.{Projects, Profiles, Repo}
  alias IssueSeeker.Profiles.{Level, Language}
  alias IssueSeeker.Projects.Contributor

  schema "projects" do
    field :name, :string
    field :owner, :string
    field :status, :string
    field :stargazers_count, :integer
    belongs_to :level, Level, on_replace: :nilify
    many_to_many :contributors, Contributor, join_through: "projects_contributors", on_replace: :delete
    many_to_many :languages, Language, join_through: "projects_languages", on_replace: :delete

    timestamps()
  end

  def create_changeset(attrs) do
    {:ok, contributors} =
      attrs
      |> Map.get("contributors")
      |> Projects.ensure_contributors_created()

    {:ok, languages} =
      attrs
      |> Map.get("languages")
      |> Profiles.ensure_languages_created()

    %Project{}
    |> cast(attrs, [:name, :owner, :stargazers_count])
    |> put_existing_assoc(:contributors, contributors)
    |> put_existing_assoc(:languages, languages)
    |> unique_constraint([:name, :owner])
  end

  @doc false
  def update_changeset(project, attrs) do
    level =
      attrs
      |> Map.get("level", "")
      |> Profiles.get_level_by_name()

    project
    |> Repo.preload([:level])
    |> cast(attrs, [:status])
    |> put_existing_assoc(:level, level)
  end

  def statuses, do: ["PENDING_APROVAL", "ACTIVE", "INACTIVE"]
end
