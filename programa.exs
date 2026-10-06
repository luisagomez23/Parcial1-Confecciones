# Parcial 1 - Programación III - Universidad del Quindío
# Integrantes: Luisa Gómez, Juan Camilo Gordillo, Juan Esteban Mejia

defmodule Programa do
  @moduledoc """
  Carga los datos, pide un lote adicional, valida, liquida e imprime los reportes.
  """

  @taller_aliado %{1 => 550, 2 => 620, 3 => 480, 5 => 710, 7 => 200}

  @doc """
  Función principal del programa.
  """
  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()

    por_codigo = Map.new(confeccionistas, fn c -> {c.codigo, c} end)
    por_id = Map.new(lineas, fn l -> {l.id, l} end)

    adicional = pedir_lote_adicional(por_codigo, por_id)
    lotes = Datos.lotes() ++ adicional

    {validos, rechazados} = Validacion.separar_lotes(lotes, por_codigo, por_id)
    liquidaciones = Liquidacion.liquidar_todos(confeccionistas, validos)

    Reportes.imprimir_r1(rechazados)
    Reportes.imprimir_r2(lineas, validos)
    Reportes.imprimir_r3(validos)
    Reportes.imprimir_r4(liquidaciones)
    Reportes.imprimir_r5(validos, confeccionistas)
    Reportes.imprimir_r6(validos, confeccionistas)
    Reportes.imprimir_r7(liquidaciones, validos)
    Reportes.imprimir_r8(lineas, validos, confeccionistas)

    imprimir_rankings(liquidaciones)
    imprimir_combinacion(validos)
    pedir_comprobante(liquidaciones)
  end

  @doc """
  Pide un lote adicional. Devuelve `[]` o una lista con el lote por agregar.
  """
  def pedir_lote_adicional(por_codigo, por_id) do
    mensaje =
      "Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos)\n" <>
        "o Enter para omitir: "

    case Util.leer_linea(mensaje) do
      {:ok, ""} ->
        IO.puts("Lote adicional omitido.")
        []

      {:ok, texto} ->
        procesar_lote_adicional(texto, por_codigo, por_id)

      {:error, _motivo} ->
        IO.puts("Lote adicional omitido (no hubo entrada).")
        []
    end
  end

  defp procesar_lote_adicional(texto, por_codigo, por_id) do
    with {:ok, lote} <- Validacion.parsear_lote(texto),
         {:ok, lote} <- Validacion.validar_lote(lote, por_codigo, por_id) do
      IO.puts("Lote adicional agregado.")
      [lote]
    else
      {:error, :formato_invalido} ->
        IO.puts("Lote adicional rechazado: formato_invalido (no se agregó).")
        []

      {:error, motivo} ->
        IO.puts("Lote adicional rechazado: #{motivo}. Aparecerá en R1.")
        [parsear_sin_validar(texto)]
    end
  end

  defp parsear_sin_validar(texto) do
    {:ok, lote} = Validacion.parsear_lote(texto)
    lote
  end

  defp imprimir_rankings(liquidaciones) do
    IO.puts("\n=== C.1. Rankings con keyword lists ===")

    Reportes.imprimir_ranking("ranking(liquidaciones, [])", Reportes.ranking(liquidaciones, []))

    Reportes.imprimir_ranking(
      "ranking(liquidaciones, campo: :prendas, limite: 3)",
      Reportes.ranking(liquidaciones, campo: :prendas, limite: 3)
    )

    Reportes.imprimir_ranking(
      "ranking(liquidaciones, orden: :asc, campo: :bruto)",
      Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto)
    )

    Reportes.imprimir_ranking(
      "ranking(liquidaciones, campo: :prendas, campo: :neto)",
      Reportes.ranking(liquidaciones, campo: :prendas, campo: :neto)
    )
  end

  defp imprimir_combinacion(validos) do
    produccion = Reportes.produccion_diaria(validos)
    combinada = Reportes.combinar_produccion(produccion, @taller_aliado)

    IO.puts("\n=== C.2. Producción combinada con el taller aliado ===")

    combinada
    |> Enum.sort_by(fn {dia, _prendas} -> dia end)
    |> Enum.each(fn {dia, prendas} -> IO.puts("  Día #{dia}: #{prendas} prendas") end)
  end

  defp pedir_comprobante(liquidaciones) do
    case Util.leer_linea("\nIngrese el código del confeccionista para su comprobante: ") do
      {:ok, codigo} -> Reportes.imprimir_comprobante(liquidaciones, codigo)
      {:error, _motivo} -> IO.puts("No se ingresó ningún código.")
    end
  end
end

Programa.main()
