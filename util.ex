defmodule Util do
  @moduledoc """
  Funciones de apoyo. Las impuras (entrada y salida) son mostrar_mensaje/1,
  leer_linea/1 e ingresar/2; el resto son puras.
  """

  # ---------- Impuras: entrada y salida ----------

  @doc """
  Imprime un mensaje en pantalla.
  """
  def mostrar_mensaje(mensaje), do: IO.puts(mensaje)

  @doc """
  Lee una línea sin espacios en los extremos. {:error, :sin_entrada} si no hay entrada.
  """
  def leer_linea(mensaje) do
    case IO.gets(mensaje) do
      texto when is_binary(texto) -> {:ok, String.trim(texto)}
      _ -> {:error, :sin_entrada}
    end
  end

  @doc """
  Pide un dato al usuario según el tipo (:texto, :entero, :flotante o :booleano).
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
        _ -> {:error, :no_booleano}
      end
    end
  end

  # ---------- Puras ----------

  @doc """
  Convierte texto a entero. {:error, :no_entero} si no lo es.
  """
  def parsear_entero(texto) do
    case Integer.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :no_entero}
    end
  end

  @doc """
  Convierte texto a número (acepta 7 o 3.5). {:error, :no_numerico} si no lo es.
  """
  def parsear_numero(texto) do
    case Float.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :no_numerico}
    end
  end

  @doc """
  Formatea un número con decimales fijos y sin notación científica.
  """
  def formatear_decimal(valor, decimales \\ 2),
    do: :erlang.float_to_binary(valor * 1.0, decimals: decimales)

  @doc """
  Formatea un valor monetario con dos decimales.
  """
  def formatear_dinero(valor), do: formatear_decimal(valor, 2)

  @doc """
  Divide; devuelve {:error, :division_por_cero} si el divisor es cero.
  """
  def dividir(_dividendo, divisor) when divisor == 0, do: {:error, :division_por_cero}
  def dividir(dividendo, divisor), do: {:ok, dividendo / divisor}
end
