defmodule NossoContador.Repo do
  use Ecto.Repo,
    otp_app: :nosso_contador,
    adapter: Ecto.Adapters.Postgres
end
