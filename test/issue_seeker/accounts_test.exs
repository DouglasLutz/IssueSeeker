defmodule IssueSeeker.AccountsTest do
  use IssueSeeker.DataCase

  alias IssueSeeker.Accounts
  alias IssueSeeker.Accounts.User

  @valid_attrs %{
    email: "some@email.com",
    name: "some name",
    nickname: "some nickname",
    token: "some token",
    image: "some url",
    description: "some description",
    bio: "some bio",
    location: "some string",
    admin: false
  }
  @update_attrs %{
    email: "some_updated@email.com",
    name: "some updated name",
    nickname: "some updated nickname",
    token: "some updated token",
    image: "some updated url",
    description: "some updated description",
    bio: "some updated bio",
    location: "some updated string",
    admin: true
  }
  @invalid_attrs %{
    email: nil,
    name: nil,
    nickname: nil,
    token: nil,
    image: nil,
    description: nil,
    bio: nil,
    location: nil,
    admin: nil
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

      user
  end

  describe "get_user/1" do
    test "returns the user with given id" do
      user = user_fixture()
      assert %User{
        email: "some@email.com",
        name: "some name",
        nickname: "some nickname",
        token: "some token",
        image: "some url",
        description: "some description",
        bio: "some bio",
        location: "some string",
        admin: false
      } = Accounts.get_user(user.id)
    end

    test "returns nil with invalid id" do
      assert nil == Accounts.get_user(42)
    end
  end

  describe "get_user_by/1" do
    test "returns the user with given fields" do
      _user = user_fixture()
      assert %User{
        email: "some@email.com",
        name: "some name",
        nickname: "some nickname",
        token: "some token",
        image: "some url",
        description: "some description",
        bio: "some bio",
        location: "some string",
        admin: false
      } = Accounts.get_user_by(@valid_attrs)
    end

    test "returns nil with invalid params" do
      assert nil == Accounts.get_user_by(%{name: "invalid name"})
    end
  end

  describe "create_user/1" do
    test "with valid data creates an user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert user.nickname == "some nickname"
      assert user.token == "some token"
      assert user.image == "some url"
      assert user.description == "some description"
      assert user.bio == "some bio"
      assert user.location == "some string"
      assert user.admin == false
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end

  describe "update_user/2" do
    test "with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some_updated@email.com"
      assert user.name == "some updated name"
      assert user.nickname == "some updated nickname"
      assert user.token == "some updated token"
      assert user.image == "some updated url"
      assert user.description == "some updated description"
      assert user.bio == "some updated bio"
      assert user.location == "some updated string"
      assert user.admin == true
    end

    test "with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    end
  end

  describe "create_or_update_user/1" do
    test "when user doesn't exist creates an user" do
      assert {:ok, %User{} = user} = Accounts.create_or_update_user(@update_attrs)
      assert user.email == "some_updated@email.com"
      assert user.name == "some updated name"
      assert user.nickname == "some updated nickname"
      assert user.token == "some updated token"
      assert user.image == "some updated url"
      assert user.description == "some updated description"
      assert user.bio == "some updated bio"
      assert user.location == "some updated string"
      assert user.admin == true
    end

    test "when user exists updates the user" do
      user_fixture()
      assert {:ok, %User{} = user} = Accounts.create_or_update_user(%{email: "some@email.com", name: "some updated name"})
      assert user.email == "some@email.com"
      assert user.name == "some updated name"
      assert user.nickname == "some nickname"
      assert user.token == "some token"
      assert user.image == "some url"
      assert user.description == "some description"
      assert user.bio == "some bio"
      assert user.location == "some string"
      assert user.admin == false
    end
  end
end
