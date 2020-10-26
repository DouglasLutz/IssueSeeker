defmodule IssueSeeker.Projects.Label do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "labels" do
    field :name, :string
  end

  def changeset(label \\ %Label{}, attrs) do
    label
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end
