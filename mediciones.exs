# Parcial 1 - Programación III - Universidad del Quindío
# Integrantes: Luisa Gómez, Juan Camilo Gordillo, Juan Esteban Mejia
defmodule Mediciones do
  @moduledoc """
  Mediciones del punto C.3: lista contra mapa para buscar por código,
  y agregar al final contra agregar al inicio de una lista.
  Se ejecuta con: elixir mediciones.exs
  """

  #Parametros como atributos del modulo
  @total_confeccionistas 100_000
  @busquedas 1_000
  @elementos 20_000
  @repeticiones 3

  @doc """
  Ejecuta las dos comparaciones e imprime los tiempos en microsegundos.
  """
  def main do
    IO.puts("=== Comparación 1: buscar #{@busquedas} códigos entre #{@total_confeccionistas} confeccionistas ===")

    lista =
      Enum.map(1..@total_confeccionistas, fn n ->
        %{codigo: "C#{n}", nombre: "Confeccionista #{n}", alquiler: rem(n, 2) == 0}
      end)

    {tiempo_mapa, mapa} =
      :timer.tc(fn ->
        lista
        |> Enum.map(fn c -> {c.codigo, c} end)
        |> Enum.into(%{})
      end)

    IO.puts("Construir el mapa indexado por código: #{tiempo_mapa} us (se hace una sola vez)")

    codigos = Enum.map(1..@busquedas, fn _ -> "C#{Enum.random(1..@total_confeccionistas)}" end)

    medir("Buscar en la lista con Enum.find/2", fn ->
      Enum.each(codigos, fn codigo -> Enum.find(lista, fn c -> c.codigo == codigo end) end)
    end)

    medir("Buscar en el mapa con Map.get/2", fn ->
      Enum.each(codigos, fn codigo -> Map.get(mapa, codigo) end)
    end)

    IO.puts("")
    IO.puts("=== Comparación 2: construir una lista de #{@elementos} elementos ===")

    medir("Agregar al final con ++", fn ->
      Enum.reduce(1..@elementos, [], fn x, acc -> acc ++ [x] end)
    end)

    medir("Agregar al inicio con [elemento | lista]", fn ->
      Enum.reduce(1..@elementos, [], fn x, acc -> [x | acc] end)
    end)
  end

  @doc """
  Ejecuta la función varias veces con :timer.tc/1 e imprime cada tiempo
  y el promedio, en microsegundos.
  """
  def medir(nombre, funcion) do
    tiempos =
      Enum.map(1..@repeticiones, fn _ ->
        {microsegundos, _resultado} = :timer.tc(funcion)
        microsegundos
      end)

    promedio = div(Enum.sum(tiempos), length(tiempos))

    IO.puts(nombre)

    tiempos
    |> Enum.with_index()
    |> Enum.each(fn {tiempo, i} -> IO.puts("  Repeticion #{i + 1}: #{tiempo} us") end)

    IO.puts("  Promedio: #{promedio} us")
  end
end

Mediciones.main()
