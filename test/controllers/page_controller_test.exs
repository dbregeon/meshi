defmodule Meshi.PageControllerTest do
  use Meshi.ConnCase

  @default_opts [
   store: :cookie,
   key: "foobar",
   encryption_salt: "encrypted cookie salt",
   signing_salt: "signing salt",
   log: false
 ]

 @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Meshi!"
  end

  test "shows a sign in with Google link when not signed in", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Sign in with Google"
  end

  test "shows a sign out link when signed in", %{conn: conn} do
    conn = conn
    |> Plug.Session.call(@signing_opts)
    |> fetch_session
    |> put_session(:current_user, %{id: "Test", avatar: nil})
    |> get("/")

    assert html_response(conn, 200) =~ "Logout"
  end
end
