defmodule NossoContador.Counter do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "counter_values" do
    field :value, :integer

    timestamps()
  end

  def changeset(counter, attrs) do
    counter
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
