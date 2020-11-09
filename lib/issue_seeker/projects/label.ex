defmodule IssueSeeker.Projects.Label do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__
  alias IssueSeeker.Projects.Issue

  schema "labels" do
    field :name, :string
    field :classification, :string

    many_to_many :issues, Issue, join_through: "issues_labels"
  end

  def create_changeset(label \\ %Label{}, attrs) do
    label
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end

  def update_changeset(label, attrs) do
    label
    |> cast(attrs, [:classification])
  end

  def classifications, do: ["GOOD", "NEUTRAL", "BAD"]
end
