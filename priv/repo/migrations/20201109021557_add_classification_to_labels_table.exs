defmodule IssueSeeker.Repo.Migrations.AddClassificationToLabelsTable do
  use Ecto.Migration

  def up do
    alter table(:labels) do
      add :classification, :string
    end
  end

  def down do
    alter table(:labels) do
      remove :classification
    end
  end
end
