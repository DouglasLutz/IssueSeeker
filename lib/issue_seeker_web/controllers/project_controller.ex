defmodule IssueSeekerWeb.ProjectController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Projects
  alias IssueSeeker.Projects.Project

  def index(conn, _params) do
    projects = Projects.list_active_projects()
    render(conn, "index.html", projects: projects, title: "Current Active Projects")
  end

  def pending_aproval(conn, _params) do
    projects = Projects.list_pending_aproval_projects()
    render(conn, "index.html", projects: projects, title: "Projects pending aproval")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"project" => %{"url" => url}}) do
    with {:ok, project_params} <- Project.get_attrs_from_url(url),
      {:ok, _project} <- Projects.create_project(project_params) do
        conn
        |> put_flash(:info, "Project sugestion submitted successfully.")
        |> redirect(to: "/")
    else
      {:error, %Ecto.Changeset{errors: [name: {"has already been taken", _}]}} ->
        conn
        |> put_flash(:error, "The project already exists.")
        |> render("new.html")
      {:error, _} ->
        conn
        |> put_flash(:error, "Couldn't find project, please try again.")
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    render(conn, "show.html", project: project)
  end

  def edit(conn, %{"id" => id}) do
    project = Projects.get_project!(id)
    changeset = Projects.change_project(project)
    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Projects.get_project!(id)

    case Projects.update_project(project, project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: Routes.project_path(conn, :show, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end
end
