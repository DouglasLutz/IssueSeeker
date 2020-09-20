defmodule IssueSeeker.Profiles.Level do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "levels" do
    field :name, :string
    field :value, :integer
  end

  def changeset(level \\ %Level{}, attrs) do
    level
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
