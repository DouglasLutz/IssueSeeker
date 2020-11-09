defmodule IssueSeekerWeb.IssueController do
  use IssueSeekerWeb, :controller

  alias IssueSeeker.Projects

  def index(conn, %{"project_id" => project_id}) do
    project = Projects.get_project!(project_id)
    issues = Projects.get_project_open_issues(project)
    render(conn, "index.html", project: project, issues: issues)
  end

  def show(conn, %{"id" => id}) do
    issue = Projects.get_issue!(id)
    render(conn, "show.html", issue: issue)
  end
end
