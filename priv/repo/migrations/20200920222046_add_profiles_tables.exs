defmodule IssueSeeker.Repo.Migrations.AddProfilesTables do
  use Ecto.Migration

  def up do
    create table(:levels) do
      add :name, :string
      add :value, :integer
    end
    create unique_index(:levels, [:name])
    execute("INSERT INTO levels (\"name\", \"value\") VALUES ('Beginner', '1'), ('Intermediate', 2), ('Advanced', 3)")

    create table(:languages) do
      add :name, :string
    end
    create unique_index(:languages, [:name])
    execute("INSERT INTO languages (\"name\") VALUES ('HTML'), ('CSS'), ('Javascript'), ('Ruby'), ('Elixir'), ('Go'), ('C#')")

    create table(:profiles) do
      add :user_id, references(:users), null: false
      add :level_id, references(:levels)

      timestamps()
    end

    create table(:profiles_languages) do
      add :profile_id, references(:profiles), null: false
      add :language_id, references(:languages), null: false
    end
  end

  def down do
    drop table(:profiles_languages)
    drop table(:profiles)
    drop index(:languages, [:name])
    drop table(:languages)
    drop index(:levels, [:name])
    drop table(:levels)
  end
end
