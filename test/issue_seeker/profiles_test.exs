defmodule IssueSeeker.ProfilesTest do
  use IssueSeeker.DataCase

  alias IssueSeeker.Profiles
  alias IssueSeeker.Profiles.{Language, Level, Profile}

  @valid_language_attrs %{
    name: "some name"
  }

  def language_fixture(attrs \\ %{}) do
    %Language{}
    |> struct!(@valid_language_attrs)
    |> struct!(attrs)
    |> IssueSeeker.Repo.insert!()
  end

  describe "list_languages/0" do
    test "returns all languages" do
      language = language_fixture()
      assert Profiles.list_languages() == [language]
    end
  end

  describe "filter_languages_by_name/1" do
    test "with a list of names returns the languages" do
      language = language_fixture()
      language_fixture(%{name: "some other name"})
      assert Profiles.filter_languages_by_name(["some name"]) == [language]
    end
  end

  describe "filter_languages_by_id/1" do
    test "with a list of ids returns the languages" do
      language = language_fixture()
      language_fixture(%{name: "some other name"})
      assert Profiles.filter_languages_by_id([language.id]) == [language]
    end
  end

  describe "ensure_languages_created/1" do
    test "with a list of names creates the nonexistent ones and returns all with given names" do
      language_fixture(%{name: "L1"})
      assert {:ok, [%Language{name: "L1"}, %Language{name: "L2"}]} = Profiles.ensure_languages_created(["L1" , "L2"])
    end
  end

  describe "create_languages/1" do
    test "with a list of names creates languages" do
      assert {:ok,
        %{
          {:language, "L1"} => %Language{name: "L1"},
          {:language, "L2"} => %Language{name: "L2"}
        }
      } = Profiles.create_languages(["L1", "L2"])
    end

    test "with duplicate name returns error" do
      language_fixture(%{name: "L1"})
      assert {:error, {:language, "L1"}, %Ecto.Changeset{}, %{}} = Profiles.create_languages(["L1"])
    end
  end

  @valid_level_attrs %{
    name: "some name"
  }

  def level_fixture(attrs \\ %{}) do
    %Level{}
    |> struct!(@valid_level_attrs)
    |> struct!(attrs)
    |> IssueSeeker.Repo.insert!()
  end

  describe "list_levels/0" do
    test "returns all level" do
      assert [%Level{name: "Beginner"}, %Level{name: "Intermediate"}, %Level{name: "Advanced"}] = Profiles.list_levels()
    end
  end

  describe "get_level_by_name/1" do
    test "returns the level with given name" do
      assert %Level{name: "Beginner"} = Profiles.get_level_by_name("Beginner")
    end

    test "returns nil with invalid name" do
      assert nil == Profiles.get_level_by_name("Random name")
    end
  end

  def valid_profile_attrs() do
    languages =
      [
        language_fixture(%{name: "L1"}),
        language_fixture(%{name: "L2"})
      ]
      |> Enum.map(&(&1.id))

    level =
      level_fixture(%{name: "L1"})
      |> Map.get(:name)

    user = IssueSeeker.AccountsTest.user_fixture(%{name: "some name"})

    %{
      "languages" => languages,
      "level" => level,
      "user" => user
    }
  end

  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(valid_profile_attrs())
      |> Profiles.create_profile()

    profile
  end

  describe "create_profile/1" do
    test "with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Profiles.create_profile(valid_profile_attrs())
      assert [%Language{name: "L1"}, %Language{name: "L2"}] = profile.languages
      assert %IssueSeeker.Accounts.User{name: "some name"} = profile.user
      assert %Level{name: "L1"} = profile.level
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_profile(%{})
    end
  end

  describe "update_profile/2" do
    test "with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{
        "level" => "Beginner",
        "languages" => []
      }

      assert {:ok, %Profile{} = profile} = Profiles.update_profile(profile, update_attrs)
      assert [] = profile.languages
      assert %Level{name: "Beginner"} = profile.level
    end
  end

  describe "change_profile/1" do
    test "returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_profile(profile)
    end
  end

  describe "get_user_profile/1" do
    test "with an user returns the associated profile" do
      profile = profile_fixture()
      assert %Profile{} = profile = Profiles.get_user_profile(profile.user)
      assert [%Language{name: "L1"}, %Language{name: "L2"}] = profile.languages
      assert %IssueSeeker.Accounts.User{name: "some name"} = profile.user
      assert %Level{name: "L1"} = profile.level
    end

    test "with invalid param returns nil" do
      assert nil == Profiles.get_user_profile(123)
    end
  end
end
