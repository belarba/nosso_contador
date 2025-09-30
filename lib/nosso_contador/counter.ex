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

  def get_last_values(limit \\ 5) do
    from(c in __MODULE__,
      order_by: [desc: c.inserted_at],
      limit: ^limit,
      select: %{value: c.value, inserted_at: c.inserted_at}
    )
    |> NossoContador.Repo.all()
  end

  def get_last_value do
    from(c in __MODULE__,
      order_by: [desc: c.inserted_at],
      limit: 1,
      select: c.value
    )
    |> NossoContador.Repo.one()
  end
end
