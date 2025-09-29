defmodule NossoContadorWeb.PageController do
  use NossoContadorWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
