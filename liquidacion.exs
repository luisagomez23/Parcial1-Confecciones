defmodule Liquidacion do
  @moduledoc """
  Cálculo del valor de lotes, bonificaciones, alquiler y neto de cada confeccionista.

  """

  @tarifa_base 3200
  @prendas_para_bonificacion 120
  @bonificacion_diaria 18_000
  @alquiler_por_dia 15_000

  @doc """
  Factor (entero) que ajusta el valor del lote según los defectos.
  """
  def factor_ajuste(defectos) when defectos <= 2, do: 107
  def factor_ajuste(defectos) when defectos <= 5, do: 100
  def factor_ajuste(defectos) when defectos <= 10, do: 88
  def factor_ajuste(_defectos), do: 75


  @doc """
  Valor de un lote válido.
  """
  def valor_lote(%{prendas: prendas, defectos: defectos}) do
    @tarifa_base * prendas * (factor_ajuste(defectos) / 100)
  end


  @doc """
  Bonificación del día según las prendas acumuladas ese día.
  """
  def bonificacion_dia(prendas) when prendas >= @prendas_para_bonificacion, do: @bonificacion_diaria


  @doc """
  Descuento por alquiler: solo si el confeccionista usa máquinas del taller.
  """
  def descuento_alquiler(true, dias_trabajados) do dias_trabajados * @alquiler_por_dia
  def descuento_alquiler(false, _dias_trabajados), do: 0


  @doc """
  Agrupa los lotes por día: prendas, valor y bonificación de cada día trabajado. Hecho con IA(Claude).
  """
  def detalle_por_dia(lotes) do
    lotes
    |> Enum.group_by(& &1.dia)
    # Enum.group_by agrupa los lotes según su fecha (el campo dia).
    |> Map.new(fn {dia, lotes_dia} ->
      prendas = lotes_dia |> Enum.map(& &1.prendas) |> Enum.sum()
      valor = lotes_dia |> Enum.map(&valor_lote/1) |> Enum.sum()
      {dia, %{prendas: prendas, valor: valor, bonificacion: bonificacion_dia(prendas)}}
    end)
  end


  @doc """
  Liquidación de un confeccionista a partir de sus lotes válidos.
  """
  def liquidacion_confeccionista(confeccionista, lotes_validos) do
    dias = detalle_por_dia(lotes_validos)
    detalles = Map.values(dias)
    # Map.values extrae todos los valores de un mapa y los devuelve en formato de lista (Visual Elixir Reference).

    prendas = detalles |> Enum.map(& &1.prendas) |> Enum.sum()
    bruto = detalles |> Enum.map(& &1.valor) |> Enum.sum()
    bonificaciones = detalles |> Enum.map(& &1.bonificacion) |> Enum.sum()
    alquiler = descuento_alquiler(confeccionista.alquiler, map_size(dias))

    %{
      codigo: confeccionista.codigo,
      nombre: confeccionista.nombre,
      prendas: prendas,
      bruto: bruto,
      bonificaciones: bonificaciones,
      alquiler: alquiler,
      neto: bruto + bonificaciones - alquiler,
      dias: dias
    }
  end

  end


  @doc """
  Liquida a todos los confeccionistas, incluso a quienes no tienen lotes válidos.
  """
  def liquidacion_confeccionistas(confeccionistas) do

  end

end
