defmodule Reportes do
  @moduledoc """
  Cálculo de los reportes de R1 a R8.
  """

  # Lista de motivos de rechazo, definida como atributo del modulo.
  @motivos [
    :confeccionista_desconocido,
    :linea_desconocida,
    :dia_invalido,
    :prendas_fuera_de_rango,
    :porcentaje_invalido
  ]

  @doc """
  R1: lotes rechazados y cantidad de rechazos por cada motivo.
  Recibe una lista de {lote, motivo}. Devuelve un mapa con el detalle,
  el total y el conteo (lista de {motivo, cantidad}, incluyendo los
  motivos que tienen cero rechazos).
  """
  def r1(rechazados) do
    conteo =
      Enum.map(@motivos, fn motivo ->
        del_motivo = Enum.filter(rechazados, fn {_lote, m} -> m == motivo end)
        {motivo, length(del_motivo)}
      end)

    %{rechazados: rechazados, total: length(rechazados), conteo: conteo}
  end

end
