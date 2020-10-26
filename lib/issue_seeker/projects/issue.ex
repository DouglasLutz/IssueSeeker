defmodule IssueSeeker.Projects.Issue do
  use Ecto.Schema

  import Ecto.Changeset
  import IssueSeeker.Helpers.Changeset

  alias __MODULE__
  alias IssueSeeker.{Projects, Repo}
  alias IssueSeeker.Projects.{Project, Label}

  schema "issues" do
    field :title, :string
    field :number, :integer
    field :body, :string
    field :author_association, :string
    field :number_of_comments, :integer
    field :has_assignee, :boolean
    field :is_open, :boolean
    field :url, :string

    belongs_to :project, Project, on_replace: :nilify
    many_to_many :labels, Label, join_through: "issues_labels"

    timestamps()
  end

  @doc false
  def create_changeset(issue \\ %Issue{}, attrs) do
    {:ok, labels} =
      attrs
      |> Map.get("labels")
      |> Projects.ensure_labels_created()

    issue
    |> cast(attrs, [:title, :number, :body, :author_association, :number_of_comments, :has_assignee, :is_open, :url])
    |> put_existing_assoc(:labels, labels)
    |> put_existing_assoc(:project, Map.get(attrs, "project"))
    |> validate_required(:project)
    |> unique_constraint([:number, :project])
  end

  def update_changeset(issue, attrs) do
    {:ok, labels} =
      attrs
      |> Map.get("labels")
      |> Projects.ensure_labels_created()

    issue
    |> Repo.preload([:labels])
    |> cast(attrs, [:title, :body, :author_association, :number_of_comments, :has_assignee, :is_open, :url])
    |> put_existing_assoc(:labels, labels)
  end
end
