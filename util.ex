defmodule Util do
  @moduledoc """
  Funciones de apoyo.
  """

  @doc """
  Imprime un mensaje en pantalla.
  """
  def mostrar_mensaje(mensaje), do: IO.puts(mensaje)

  @doc """
  Lee una línea sin espacios en los extremos.
  Devuelve "{:error, :sin_entrada}" si no hay entrada.
  """
  def leer_linea(mensaje) do
    case IO.gets(mensaje) do
      texto when is_binary(texto) -> {:ok, String.trim(texto)}
      _ -> {:error, :sin_entrada}
    end
  end

  @doc """
  Pide un dato al usuario según el tipo (`:texto`, `:entero`, `:flotante` o `:booleano`).
  Devuelve `{:ok, valor}` o `{:error, motivo}`.
  """
  def ingresar(mensaje, :texto), do: leer_linea(mensaje)

  def ingresar(mensaje, :entero) do
    with {:ok, texto} <- leer_linea(mensaje), do: parsear_entero(texto)
  end

  def ingresar(mensaje, :flotante) do
    with {:ok, texto} <- leer_linea(mensaje), do: parsear_numero(texto)
  end

  def ingresar(mensaje, :booleano) do
    with {:ok, texto} <- leer_linea(mensaje) do
      case String.downcase(texto) do
        respuesta when respuesta in ["s", "si", "sí", "true"] -> {:ok, true}
        respuesta when respuesta in ["n", "no", "false"] -> {:ok, false}
        _ -> {:error, :formato_invalido}
      end
    end
  end


  @doc """
  Convierte un texto a entero.
  Devuelve `{:error, :formato_invalido}` si no lo es.
  """
  def parsear_entero(texto) do
    case Integer.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :formato_invalido}
    end
  end

  @doc """
  Convierte un texto a número (acepta "7" y "3.5").
  Devuelve `{:error, :formato_invalido}` si no lo es.
  """
  def parsear_numero(texto) do
    case Float.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :formato_invalido}
    end
  end

  @doc """
  Formatea un número con decimales fijos y sin notación científica.
  """
  def formatear_decimal(valor, decimales \\ 2),
    do: :erlang.float_to_binary(valor * 1.0, decimals: decimales)

  @doc """
  Formatea un valor monetario con signo `$`, dos decimales y sin notación científica.
  """
  def formatear_dinero(valor) do
    centavos = round(valor * 100)
    signo = if centavos < 0, do: "-", else: ""
    absoluto = abs(centavos)
    pesos = div(absoluto, 100)
    resto = absoluto |> rem(100) |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{signo}$#{pesos}.#{resto}"
  end

  @doc """
  Divide dos números. Devuelve `{:error, :division_por_cero}` si el divisor es cero.
  """
  def dividir(_dividendo, divisor) when divisor == 0, do: {:error, :division_por_cero}
  def dividir(dividendo, divisor), do: {:ok, dividendo / divisor}
end
