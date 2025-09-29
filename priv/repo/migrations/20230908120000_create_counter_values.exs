defmodule NossoContador.Repo.Migrations.CreateCounterValues do
  use Ecto.Migration

  def change do
    create table(:counter_values) do
      add :value, :integer, null: false

      timestamps()
    end
  end
end
