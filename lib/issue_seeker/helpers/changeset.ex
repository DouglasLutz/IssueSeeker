defmodule IssueSeeker.Helpers.Changeset do
  import Ecto.Changeset

  def put_existing_assoc(changeset, _name, nil), do: changeset
  def put_existing_assoc(changeset, name, value), do: put_assoc(changeset, name, value)
end
