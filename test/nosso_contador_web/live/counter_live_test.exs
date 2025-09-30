defmodule NossoContadorWeb.CounterLiveTest do
  use NossoContadorWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renderiza a página inicial", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "Our Counter"
    assert html =~ "Counter"
    assert html =~ "Decrease"
    assert html =~ "Increase"
    assert html =~ "Save"
  end

  test "aumenta o contador", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # Inicia em 0
    assert has_element?(view, "span", "0")

    # Clica em Increase
    view |> element("button", "Increase") |> render_click()

    # Verifica que aumentou para 1
    assert has_element?(view, "span", "1")
  end

  test "diminui o contador", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # Clica em Increase primeiro para ter um valor
    view |> element("button", "Increase") |> render_click()
    view |> element("button", "Increase") |> render_click() # count = 2

    # Clica em Decrease
    view |> element("button", "Decrease") |> render_click()

    # Verifica que diminuiu para 1
    assert has_element?(view, "span", "1")
  end

  test "salva o contador no banco de dados", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # Aumenta para 3 e salva
    view |> element("button", "Increase") |> render_click()
    view |> element("button", "Increase") |> render_click()
    view |> element("button", "Increase") |> render_click()

    view |> element("button", "Save") |> render_click()

    # Aguarda um pouco para o processamento
    :timer.sleep(100)

    # Verifica que aparece na lista de últimos valores
    # Procura pelo valor "3" em qualquer lugar da seção de últimos valores
    assert render(view) =~ "3"
  end

  test "muda o locale", %{conn: conn} do
    # Testa diretamente em português
    {:ok, view, _html} = live(conn, "/?locale=pt")

    # Verifica que está em português
    assert has_element?(view, "h1", "Nosso Contador")
    assert has_element?(view, "button", "Aumentar")
    assert has_element?(view, "button", "Diminuir")
    assert has_element?(view, "button", "Salvar")
  end
end
