defmodule NossoContadorWeb.CounterLive do
  use NossoContadorWeb, :live_view
  alias NossoContador.Counter
  alias NossoContador.Repo

  @impl true
  def mount(_params, _session, socket) do
    last_values = Counter.get_last_values()
    locale = Gettext.get_locale(NossoContadorWeb.Gettext)

    socket =
      socket
      |> assign(:count, 0)
      |> assign(:last_values, last_values)
      |> assign(:locale, locale)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    locale = params["locale"] || socket.assigns.locale || "en"

    # Atualiza o locale no Gettext
    Gettext.put_locale(NossoContadorWeb.Gettext, locale)

    socket = assign(socket, :locale, locale)
    {:noreply, socket}
  end

  @impl true
  def handle_event("increase", _params, socket) do
    new_count = socket.assigns.count + 1
    {:noreply, update_count(socket, new_count)}
  end

  def handle_event("decrease", _params, socket) do
    new_count = socket.assigns.count - 1
    {:noreply, update_count(socket, new_count)}
  end

  def handle_event("save", _params, socket) do
    save_count(socket.assigns.count)
    last_values = Counter.get_last_values()

    socket =
      socket
      |> assign(:last_values, last_values)
      |> push_event("show_notification", %{
          message: Gettext.gettext(NossoContadorWeb.Gettext, "The counter is now: %{count}", count: socket.assigns.count)
      })

    {:noreply, socket}
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
