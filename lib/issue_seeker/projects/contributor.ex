defmodule IssueSeeker.Projects.Contributor do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "contributors" do
    field :name, :string

    timestamps()
  end

  def changeset(contributor \\ %Contributor{}, attrs) do
    contributor
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint([:name])
  end
end
