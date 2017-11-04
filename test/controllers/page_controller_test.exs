defmodule Meshi.PageControllerTest do
  use Meshi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Meshi!"
  end
end
