defmodule NossoContadorWeb.PageControllerTest do
  use NossoContadorWeb.ConnCase

  test "GET / redireciona para o LiveView do contador", %{conn: conn} do
    conn = get(conn, ~p"/")

    # Verifica que redireciona para a página do LiveView
    assert html_response(conn, 200) =~ "Our Counter"
    assert html_response(conn, 200) =~ "Counter"
  end
end
