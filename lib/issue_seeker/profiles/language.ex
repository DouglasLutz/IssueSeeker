defmodule IssueSeeker.Profiles.Language do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "languages" do
    field :name, :string
  end

  def changeset(language \\ %Language{}, attrs) do
    language
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
