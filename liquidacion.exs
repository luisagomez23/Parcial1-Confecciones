defmodule Liquidacion do
  @moduledoc """
  Cálculo del valor de lotes, bonificaciones, alquiler y neto de cada confeccionista.

  """

  @tarifa_base 3200
  @prendas_para_bonificacion 120
  @bonificacion_diaria 18_000
  @alquiler_por_dia 15_000

  @doc "Factor (entero) que ajusta el valor del lote según los defectos."

  def factor_ajuste(defectos) when defectos <= 2, do: 107
  def factor_ajuste(defectos) when defectos <= 5, do: 100
  def factor_ajuste(defectos) when defectos <= 10, do: 88
  def factor_ajuste(_defectos), do: 75


  @doc "Valor de un lote válido."

  def valor_lote(%{prendas: prendas, defectos: defectos}) do
    @tarifa_base * prendas * (factor_ajuste(defectos) / 100)
  end


  @doc "Bonificación del día según las prendas acumuladas ese día."

  def bonificacion_dia(prendas) do

  end


  @doc "Descuento por alquiler: solo si el confeccionista usa máquinas del taller."

  def descuento_alquiler(dias) do

  end


  @doc "Agrupa los lotes por día: prendas, valor y bonificación de cada día trabajado."

  def agrupa_lotes_por_dia(lotes) do

  end


  @doc "Liquidación de un confeccionista a partir de sus lotes válidos."

  def liquidacion_confeccionista(lotes) do

  end


  @doc "Liquida a todos los confeccionistas, incluso a quienes no tienen lotes válidos."

  def liquidacion_confeccionistas(confeccionistas) do

  end

end
