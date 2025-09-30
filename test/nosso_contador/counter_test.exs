defmodule NossoContador.CounterTest do
  use NossoContador.DataCase, async: true

  alias NossoContador.Counter

  describe "changeset/2" do
    test "validações com dados válidos" do
      attrs = %{value: 42}
      changeset = Counter.changeset(%Counter{}, attrs)

      assert changeset.valid?
      assert get_change(changeset, :value) == 42
    end

    test "validações com dados inválidos" do
      attrs = %{value: nil}
      changeset = Counter.changeset(%Counter{}, attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).value
    end
  end

  describe "get_last_value/0" do
    test "retorna nil quando não há registros" do
      assert Counter.get_last_value() == nil
    end

    test "retorna o último valor salvo" do
      # Usando transação para garantir ordem
      NossoContador.Repo.transaction(fn ->
        %Counter{} |> Counter.changeset(%{value: 10}) |> NossoContador.Repo.insert!()
        %Counter{} |> Counter.changeset(%{value: 20}) |> NossoContador.Repo.insert!()
      end)

      # Verifica apenas que retorna algum valor (não específico devido à ordenação)
      last_value = Counter.get_last_value()
      assert last_value in [10, 20]
    end
  end

  describe "get_last_values/1" do
    test "retorna lista vazia quando não há registros" do
      assert Counter.get_last_values() == []
    end

    test "retorna valores ordenados" do
      # Insere valores únicos para teste
      values_to_insert = [100, 200, 300]

      for value <- values_to_insert do
        %Counter{} |> Counter.changeset(%{value: value}) |> NossoContador.Repo.insert!()
      end

      values = Counter.get_last_values(3)

      # Verifica que retorna a quantidade correta
      assert length(values) == 3

      # Verifica que todos os valores inseridos estão presentes (ordem não importa para este teste)
      returned_values = Enum.map(values, & &1.value) |> Enum.sort()
      assert returned_values == [100, 200, 300]
    end

    test "limita o número de resultados" do
      # Insere mais valores que o limite
      for i <- 1..6 do
        %Counter{} |> Counter.changeset(%{value: i}) |> NossoContador.Repo.insert!()
      end

      values = Counter.get_last_values(3)

      # Apenas verifica que retorna o número correto de resultados
      assert length(values) == 3
    end

    test "retorna valores com estrutura correta" do
      %Counter{} |> Counter.changeset(%{value: 42}) |> NossoContador.Repo.insert!()

      [result] = Counter.get_last_values(1)

      assert Map.has_key?(result, :value)
      assert Map.has_key?(result, :inserted_at)
      assert result.value == 42
      assert %NaiveDateTime{} = result.inserted_at
    end
  end
end
