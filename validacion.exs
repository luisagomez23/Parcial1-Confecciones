defmodule Validacion do
  @moduledoc """
  Validación de lotes.
  """


  # Parametros como atributos del módulo.
  @dia_minimo 1
  @dia_maximo 6
  @prendas_minimas 1
  @prendas_maximas 180

  @doc """
  Valida un lote aplicando las 5 reglas en orden.
  """
  def validar_lote(lote, confeccionistas, lineas) do
    with :ok <- verificar_confeccionista(lote, confeccionistas),
        :ok <- verificar_linea(lote, lineas),
        :ok <- verificar_dia(Map.get(lote, :dia)),
        :ok <- verificar_prendas(Map.get(lote, :prendas)),
        :ok <- verificar_porcentaje(Map.get(lote, :defectos)) do
      {:ok, lote}
    else
      {:error, motivo} -> {:error, motivo}
    end
  end

  @doc """
  Valida una lista de lotes y los separa en validos y rechazados.
  """
  def separar_lotes(lotes, confeccionistas, lineas) do
    resultados =
      Enum.map(lotes, fn lote -> {lote, validar_lote(lote, confeccionistas, lineas)} end)

    validos =
      resultados
      |> Enum.filter(fn {_lote, resultado} -> elem(resultado, 0) == :ok end)
      |> Enum.map(fn {lote, _resultado} -> lote end)

    rechazados =
      resultados
      |> Enum.filter(fn {_lote, resultado} -> elem(resultado, 0) == :error end)
      |> Enum.map(fn {lote, {:error, motivo}} -> {lote, motivo} end)

    {validos, rechazados}
  end

  @doc """
  Convierte la línea escrita por el usuario (confeccionista;linea;dia;prendas;defectos)
  en un mapa de lote.
  """
  def parsear_lote(texto) do
    campos = texto |> String.split(";") |> Enum.map(&String.trim/1)

    case campos do
      [confeccionista, linea, dia_texto, prendas_texto, defectos_texto] ->
        dia = Util.parsear_entero(dia_texto)
        prendas = Util.parsear_entero(prendas_texto)
        defectos = Util.parsear_numero(defectos_texto)

        case {dia, prendas, defectos} do
          {{:ok, d}, {:ok, p}, {:ok, x}} ->
            {:ok,
             %{confeccionista: confeccionista, linea: linea, dia: d, prendas: p, defectos: x}}

          _ ->
            {:error, :formato_invalido}
        end

      _ ->
        {:error, :formato_invalido}
    end
  end

  defp verificar_confeccionista(lote, confeccionistas) do
    if Map.has_key?(confeccionistas, Map.get(lote, :confeccionista)) do
      :ok
    else
      {:error, :confeccionista_desconocido}
    end
  end

  defp verificar_linea(lote, lineas) do
    if Map.has_key?(lineas, Map.get(lote, :linea)) do
      :ok
    else
      {:error, :linea_desconocida}
    end
  end

  defp verificar_dia(dia) do
    if is_integer(dia) and dia >= @dia_minimo and dia <= @dia_maximo do
      :ok
    else
      {:error, :dia_invalido}
    end
  end

  defp verificar_prendas(prendas) do
    if is_integer(prendas) and prendas >= @prendas_minimas and prendas <= @prendas_maximas do
      :ok
    else
      {:error, :prendas_fuera_de_rango}
    end
  end

  defp verificar_porcentaje(defectos) do
    if is_number(defectos) and defectos >= 0 and defectos <= 100 do
      :ok
    else
      {:error, :porcentaje_invalido}
    end
  end
end
