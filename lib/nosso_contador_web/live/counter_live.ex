defmodule NossoContadorWeb.CounterLive do
  use NossoContadorWeb, :live_view
  alias NossoContador.Counter
  alias NossoContador.Repo

  @impl true
  def mount(_params, _session, socket) do
    last_value = Counter.get_last_value() || 0
    last_values = Counter.get_last_values()
    locale = Gettext.get_locale(NossoContadorWeb.Gettext)

    socket =
      socket
      |> assign(:count, last_value)
      |> assign(:last_values, last_values)
      |> assign(:locale, locale)
      |> assign(:dropdown_open, false)  # Estado do dropdown

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    locale = params["locale"] || socket.assigns.locale || "en"

    # Atualiza o locale no Gettext
    Gettext.put_locale(NossoContadorWeb.Gettext, locale)

    socket =
      socket
      |> assign(:locale, locale)
      |> assign(:dropdown_open, false)  # Fecha o dropdown ao mudar locale

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle-dropdown", _params, socket) do
    {:noreply, assign(socket, :dropdown_open, !socket.assigns.dropdown_open)}
  end

  def handle_event("increase", _params, socket) do
    new_count = socket.assigns.count + 1
    {:noreply, update_count(socket, new_count)}
  end

  def handle_event("decrease", _params, socket) do
    new_count = socket.assigns.count - 1
    {:noreply, update_count(socket, new_count)}
  end

  def handle_event("save", _params, socket) do
    current_count = socket.assigns.count
    last_saved_value = Counter.get_last_value()

    # Só salva se o valor for diferente do último salvo ou se não houver último valor
    if last_saved_value == nil || current_count != last_saved_value do
      save_count(current_count)
      last_values = Counter.get_last_values()

      socket =
        socket
        |> assign(:last_values, last_values)
        |> push_event("show_notification", %{
            message: Gettext.gettext(NossoContadorWeb.Gettext, "Value saved: %{count}", count: current_count)
        })

      {:noreply, socket}
    else
      # Valor igual ao último salvo, mostra mensagem diferente
      socket =
        socket
        |> push_event("show_notification", %{
            message: Gettext.gettext(NossoContadorWeb.Gettext, "Value already saved: %{count}", count: current_count)
        })

      {:noreply, socket}
    end
  end

  defp update_count(socket, new_count) do
    socket
    |> assign(:count, new_count)
  end

  defp save_count(count) do
    %Counter{}
    |> Counter.changeset(%{value: count})
    |> Repo.insert()
  end
end
