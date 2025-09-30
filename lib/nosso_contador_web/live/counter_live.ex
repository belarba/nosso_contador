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
      |> assign(:dropdown_open, false)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    locale = params["locale"] || socket.assigns.locale || "en"

    Gettext.put_locale(NossoContadorWeb.Gettext, locale)

    socket =
      socket
      |> assign(:locale, locale)
      |> assign(:dropdown_open, false)

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
    current_count = socket.assigns.count
    last_saved_value = Counter.get_last_value()

    if last_saved_value == nil || current_count != last_saved_value do
      save_count(current_count)
      last_values = Counter.get_last_values()

      {:noreply,
        socket
        |> assign(:last_values, last_values)
        |> push_event("show-notification", %{
          type: "success",
          title: gettext("Saved!"),
          message: gettext("The counter is now: %{count}", count: current_count),
          duration: 4000
        })
      }
    else
      {:noreply,
        push_event(socket, "show-notification", %{
          type: "warning",
          title: gettext("Already Saved"),
          message: gettext("Value already saved: %{count}", count: current_count),
          duration: 3000
        })
      }
    end
  end

  def handle_event("toggle-dropdown", _params, socket) do
    {:noreply, assign(socket, :dropdown_open, !socket.assigns.dropdown_open)}
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
