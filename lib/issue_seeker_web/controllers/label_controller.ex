defmodule IssueSeekerWeb.LabelController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Projects

  def index(conn, _params) do
    labels = Projects.list_labels()
    render(conn, "index.html", labels: labels)
  end

  def issues(conn, %{"id" => id}) do
    label = Projects.get_label!(id)
    issues = Projects.issues_with_label(label)

    render(conn, "issues.html", issues: issues, label: label)
  end

  def edit(conn, %{"id" => id}) do
    label = Projects.get_label!(id)
    changeset = Projects.change_label(label)
    render(conn, "edit.html", label: label, changeset: changeset)
  end

  def update(conn, %{"id" => id, "label" => label_params}) do
    label = Projects.get_label!(id)

    case Projects.update_label(label, label_params) do
      {:ok, _label} ->
        conn
        |> put_flash(:info, "Label updated successfully.")
        |> redirect(to: Routes.label_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", label: label, changeset: changeset)
    end
  end
end
