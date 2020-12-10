defmodule IssueSeeker.ProjectsTest do
  use IssueSeeker.DataCase

  import Mock
  alias IssueSeeker.Projects
  alias IssueSeeker.Projects.{Project, Contributor, Issue, Label}

  @valid_contributor_attrs %{
    name: "some name"
  }

  def contributor_fixture(attrs \\ %{}) do
    %Contributor{}
    |> struct!(@valid_contributor_attrs)
    |> struct!(attrs)
    |> IssueSeeker.Repo.insert!()
  end

  describe "filter_contributors_by_name/1" do
    test "with a list of names returns the contributors" do
      contributor = contributor_fixture()
      contributor_fixture(%{name: "some other name"})
      assert Projects.filter_contributors_by_name(["some name"]) == [contributor]
    end
  end

  describe "ensure_contributors_created/1" do
    test "with a list of names creates the nonexistent ones and returns all with given names" do
      contributor_fixture(%{name: "C1"})
      assert {:ok, [%Contributor{name: "C1"}, %Contributor{name: "C2"}]} = Projects.ensure_contributors_created(["C1" , "C2"])
    end
  end

  describe "create_contributors/1" do
    test "with a list of names creates contributors" do
      assert {:ok,
        %{
          {:contributor, "C1"} => %Contributor{name: "C1"},
          {:contributor, "C2"} => %Contributor{name: "C2"}
        }
      } = Projects.create_contributors(["C1", "C2"])
    end

    test "with duplicate name returns error" do
      contributor_fixture(%{name: "C1"})
      assert {:error, {:contributor, "C1"}, %Ecto.Changeset{}, %{}} = Projects.create_contributors(["C1"])
    end
  end

  @valid_label_attrs %{
    name: "some name",
    classification: "GOOD"
  }

  def label_fixture(attrs \\ %{}) do
    %Label{}
    |> struct!(@valid_label_attrs)
    |> struct!(attrs)
    |> IssueSeeker.Repo.insert!()
  end

  describe "filter_labels_by_name/1" do
    test "with a list of names returns the labels" do
      label = label_fixture()
      label_fixture(%{name: "some other name"})
      assert Projects.filter_labels_by_name(["some name"]) == [label]
    end
  end

  describe "ensure_labels_created/1" do
    test "with a list of names creates the nonexistent ones and returns all with given names" do
      label_fixture(%{name: "L1"})
      assert {:ok, [%Label{name: "L1"}, %Label{name: "L2"}]} = Projects.ensure_labels_created(["L1" , "L2"])
    end
  end

  describe "create_labels/1" do
    test "with a list of names creates labels" do
      assert {:ok,
        %{
          {:label, "L1"} => %Label{name: "L1"},
          {:label, "L2"} => %Label{name: "L2"}
        }
      } = Projects.create_labels(["L1", "L2"])
    end

    test "with duplicate name returns error" do
      label_fixture(%{name: "L1"})
      assert {:error, {:label, "L1"}, %Ecto.Changeset{}, %{}} = Projects.create_labels(["L1"])
    end
  end

  describe "list_labels/0" do
    test "returns all the labels" do
      label1 = label_fixture()
      label2 = label_fixture(%{name: "some other name"})
      assert Projects.list_labels() == [label1, label2]
    end
  end

  describe "get_label!/1" do
    test "with a valid id returns the label" do
      label = label_fixture()
      assert Projects.get_label!(label.id) == label
    end

    test "with a nonexistent id raises Ecto.NoResultsError" do
      assert_raise(Ecto.NoResultsError, fn -> Projects.get_label!(123) end)
    end
  end

  describe "change_label/1" do
    test "returns a label changeset" do
      label = label_fixture()
      assert %Ecto.Changeset{} = Projects.change_label(label)
    end
  end

  describe "update_label/2" do
    test "with valid data updates the label" do
      label = label_fixture()
      update_attrs = %{
        "classification" => "BAD"
      }

      assert {:ok, %Label{} = label} = Projects.update_label(label, update_attrs)
      assert label.classification == "BAD"
    end
  end

  @valid_project_attrs %{
    "name" => "some name",
    "owner" => "some owner",
    "stargazers_count" => 42,
    "contributors" => ["some name"],
    "languages" => ["some name"]
  }

  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(@valid_project_attrs)
      |> Projects.create_project()

    project
  end

  @valid_project_update_attrs %{
    "level" => "Beginner",
    "status" => "ACTIVE"
  }

  def aproved_project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(@valid_project_attrs)
      |> Projects.create_project()

    {:ok, project} =
      project
      |> Projects.update_project(
        Enum.into(attrs, @valid_project_update_attrs)
      )

    project
  end

  describe "get_project!/1" do
    test "with a valid id returns the project" do
      project = project_fixture()
      assert %Project{} = Projects.get_project!(project.id)
    end

    test "with a nonexistent id raises Ecto.NoResultsError" do
      assert_raise(Ecto.NoResultsError, fn -> Projects.get_project!(123) end)
    end
  end

  describe "list_active_projects/0" do
    test "returns all the projects that have already been aproved" do
      project = aproved_project_fixture()
      project_fixture(%{"name" => "some other name"})
      assert Projects.list_active_projects() == [project]
    end
  end

  describe "list_pending_aproval_projects/0" do
    test "returns all the projects that have not been aproved" do
      aproved_project_fixture()
      project = project_fixture(%{"name" => "some other name"})
      assert Projects.list_pending_aproval_projects() == [project]
    end
  end

  describe "create_project/1" do
    test "with valid data creates a project" do
      assert {:ok, %Project{} = project} = Projects.create_project(@valid_project_attrs)
      assert project.name == "some name"
      assert project.owner == "some owner"
      assert project.stargazers_count == 42
      assert project.last_issues_request == nil
      assert [%Contributor{name: "some name"}] = project.contributors
      assert [%IssueSeeker.Profiles.Language{name: "some name"}] = project.languages
    end

    test "with duplicate name and owner returns error changeset" do
      assert {:ok, %Project{}} = Projects.create_project(@valid_project_attrs)
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@valid_project_attrs)
    end
  end

  describe "update_project/2" do
    test "with valid data updates the project" do
      project = project_fixture()

      assert {:ok, %Project{} = project} = Projects.update_project(project, @valid_project_update_attrs)
      assert project.status == "ACTIVE"
      assert %IssueSeeker.Profiles.Level{name: "Beginner"} = project.level
    end
  end

  describe "change_project/1" do
    test "returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end

  describe "get_project_attrs_from_url/2" do
    test "returns the project attrs" do
      with_mocks(HttpMocks.get()) do
        assert {:ok, %{
          "contributors" => [], # Does not take the contributors yet
          "contributors_url" => "https://api.github.com/repos/owner/name/contributors",
          "languages" => ["Elixir"],
          "languages_url" => "https://api.github.com/repos/owner/name/languages",
          "name" => "name",
          "owner" => "owner",
          "stargazers_count" => 42
        }} = Projects.get_project_attrs_from_url("url", "token")
      end
    end
  end

  describe "update_last_issue_request/1" do
    test "updates the last_issues_request field to current DateTime" do
      project = project_fixture()
      assert %Project{} = project = Projects.update_last_issue_request(project)
      assert project.last_issues_request != nil
    end
  end

  describe "update_project_issues_from_github/1" do
    test "returns the updated issues from github request" do
      with_mocks(HttpMocks.get()) do
        project = project_fixture()

        assert {:ok, %{
          {:issue, 42} => %Issue{} = issue
        }} = Projects.update_project_issues_from_github(project, nil)

        assert issue.number == 42
        assert issue.title == "some title"
        assert issue.body == "some body"
        assert issue.author_association == "CONTRIBUTOR"
        assert issue.has_assignee == false
        assert issue.is_open == true
        assert issue.number_of_comments == 42
      end
    end
  end

  describe "verify_issues_update/1" do
    test "calls update project issues function when last update was more than 1 hour ago" do
      #TODO
      assert true
    end

    test "does nothing when last update was less than 1 hour ago" do
      #TODO
      assert true
    end
  end

  describe "get_issue!/1" do
    test "with a valid id returns the issue" do
      #TODO
      assert true
    end

    test "with a nonexistent id raises Ecto.NoResultsError" do
      assert_raise(Ecto.NoResultsError, fn -> Projects.get_issue!(123) end)
    end
  end

  describe "issues_with_label/1" do
    test "with a label returns the associated issues" do
      #TODO
      assert true
    end
  end

  describe "get_project_issues/1" do
    test "with a project returns the associated issues" do
      #TODO
      assert true
    end
  end

  describe "get_project_open_issues/1" do
    test "with a project returns the associated issues that are open" do
      #TODO
      assert true
    end
  end

  describe "get_issue_from_project_and_number/1" do
    test "with a project and a valid number returns the issue" do
      #TODO
      assert true
    end

    test "with a project and a nonexistent number returns nil" do
      #TODO
      assert true
    end
  end

  describe "set_issues_closed/1" do
    test "with a project closes all the associated issues" do
      #TODO
      assert true
    end
  end

  describe "create_or_update_issues/2" do
    test "with valid issue attrs creates an issue when it doesn't exist" do
      #TODO
      assert true
    end

    test "with valid issue attrs updates an issue when it already exists" do
      #TODO
      assert true
    end
  end
end
