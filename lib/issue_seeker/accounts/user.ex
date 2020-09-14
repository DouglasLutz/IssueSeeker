defmodule IssueSeeker.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "users" do
    field :email, :string
    field :name, :string
    field :nickname, :string
    field :token, :string
    field :image, :string
    field :description, :string
    field :bio, :string
    field :location, :string
    field :admin, :boolean, default: false

    timestamps()
  end

  def changeset(user \\ %User{}, attrs) do
    user
    |> cast(attrs, [:email, :name, :nickname, :token, :image, :description, :bio, :location, :admin])
    |> validate_required([:email, :nickname, :token])
  end
end
