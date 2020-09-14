defmodule IssueSeeker.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :nickname, :string
      add :token, :string
      add :image, :string
      add :description, :text
      add :bio, :text
      add :location, :string
      add :admin, :boolean, default: false

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
