defmodule IssueSeekerWeb.AuthControllerTest do
  use IssueSeekerWeb.ConnCase

  describe "callback" do
    test "with ueberauth_auth signs user in", %{conn: _conn} do
      # TODO
      assert true
    end

    test "with ueberauth_failure redirects with error", %{conn: _conn} do
      # TODO
      assert true
    end
  end

  describe "signout" do
    test "drops user session", %{conn: _conn} do
      # TODO
      assert true
    end
  end
end
