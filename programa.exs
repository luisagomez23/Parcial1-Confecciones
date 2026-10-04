defmodule Programa do
  @moduledoc """
  Carga los datos, valida los lotes e imprime los reportes.
  """

  @doc """
  Es la función principal
  """
  def main do
    confeccionistas =
      Datos.confeccionistas()
      |> Enum.map(fn c -> {c.codigo, c} end)
      |> Enum.into(%{})

    lineas =
      Datos.lineas()
      |> Enum.map(fn l -> {l.id, l} end)
      |> Enum.into(%{})

    {_validos, rechazados} = Validacion.separar_lotes(Datos.lotes(), confeccionistas, lineas)

    imprimir_r1(Reportes.r1(rechazados))
  end

  @doc """
  Imprime el reporte R1: cada lote rechazado con su motivo, el total
  de rechazados y la cantidad de rechazos por cada motivo.
  """
  def imprimir_r1(resultado) do
    IO.puts("=== R1. Lotes rechazados ===")

    if resultado.rechazados == [] do
      IO.puts("No hubo lotes rechazados.")
    else
      Enum.each(resultado.rechazados, fn {lote, motivo} ->
        IO.puts("  #{inspect(lote)} -> #{motivo}")
      end)
    end

    IO.puts("Total rechazados: #{resultado.total}")
    IO.puts("Rechazos por motivo:")
    Enum.each(resultado.conteo, fn {motivo, cantidad} -> IO.puts("  #{motivo}: #{cantidad}") end)
  end


end

Programa.main()
