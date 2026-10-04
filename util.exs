defmodule Util do
  @moduledoc """
  Funciones de apoyo.
  """

  @doc """
  Convierte un texto a entero.
  """
  def parsear_entero(texto) do
    case Integer.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :formato_invalido}
    end
  end

  @doc """
  Convierte un texto a número (acepta "7" y "3.5").
  """
  def parsear_numero(texto) do
    case Float.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :formato_invalido}
    end
  end

  @doc """
  Formatea un valor monetario con dos decimales y sin notación científica.
  """
  def formatear_dinero(valor) do
    centavos = round(valor * 100)
    signo = if centavos < 0, do: "-", else: ""
    absoluto = abs(centavos)
      pesos = div(absoluto, 100)
      resto = absoluto |> rem(100) |> Integer.to_string() |> String.pad_leading(2, "0")

      "#{signo}$#{pesos}.#{resto}"
  end

end
