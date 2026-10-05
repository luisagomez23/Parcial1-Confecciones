# Parcial 1 - Programación III - Universidad del Quindío
# Integrantes: Luisa Gómez, Juan Camilo Gordillo, Juan Esteban Mejia

defmodule Reportes do

  @dias_produccion 1..6
  @meta_diaria 600
  @minimo_lotes_calidad 3

  @motivos [
    :confeccionista_desconocido,
    :linea_desconocida,
    :dia_invalido,
    :prendas_fuera_de_rango,
    :porcentaje_invalido
  ]

  @campos_ranking [:neto, :prendas, :bruto]
  @ordenes_ranking [:desc, :asc]

  # ---------------------------------------------------------------
  # R1. Lotes rechazados
  # ---------------------------------------------------------------

  @doc "Cuenta los lotes rechazados por cada motivo (incluye los motivos con cero)."
  def conteo_por_motivo(rechazados) do
    frecuencias = Enum.frequencies_by(rechazados, fn {_lote, motivo} -> motivo end)

    for motivo <- @motivos, do: {motivo, Map.get(frecuencias, motivo, 0)}
  end

  @doc "R1: imprime los lotes rechazados y la cantidad de rechazos por motivo."
  def imprimir_r1(rechazados) do
    IO.puts("\n=== R1. Lotes rechazados ===")
    imprimir_rechazados(rechazados)

    IO.puts("\nRechazos por motivo:")

    Enum.each(conteo_por_motivo(rechazados), fn {motivo, cantidad} ->
      IO.puts("  #{motivo}: #{cantidad}")
    end)
  end

  defp imprimir_rechazados([]), do: IO.puts("No hubo lotes rechazados.")

  defp imprimir_rechazados(rechazados) do
    Enum.each(rechazados, fn {lote, motivo} ->
      IO.puts("  #{describir_lote(lote)} -> #{motivo}")
    end)
  end

  defp describir_lote(lote) do
    "confeccionista=#{inspect(Map.get(lote, :confeccionista))} " <>
      "linea=#{inspect(Map.get(lote, :linea))} " <>
      "dia=#{inspect(Map.get(lote, :dia))} " <>
      "prendas=#{inspect(Map.get(lote, :prendas))} " <>
      "defectos=#{inspect(Map.get(lote, :defectos))}"
  end

  # ---------------------------------------------------------------
  # R2. Prendas y productividad por línea
  # ---------------------------------------------------------------

  @doc """
  Prendas y productividad (prendas / puestos) de cada línea, de mayor a menor.
  Las líneas sin lotes válidos aparecen con cero prendas.
  """
  def productividad_por_linea(lineas, lotes_validos) do
    prendas_linea = Util.prendas_por(lotes_validos, fn lote -> lote.linea end)

    lineas
    |> Enum.map(fn linea ->
      prendas = Map.get(prendas_linea, linea.id, 0)

      %{
        id: linea.id,
        nombre: linea.nombre,
        puestos: linea.puestos,
        prendas: prendas,
        productividad: productividad(prendas, linea.puestos)
      }
    end)
    |> Enum.sort_by(fn linea -> linea.productividad end, :desc)
  end

  @doc "R2: imprime prendas y productividad por línea."
  def imprimir_r2(lineas, lotes_validos) do
    IO.puts("\n=== R2. Producción y productividad por línea ===")

    lineas
    |> productividad_por_linea(lotes_validos)
    |> Enum.each(fn linea ->
      IO.puts(
        "  #{String.pad_trailing(linea.id, 4)}" <>
          "#{String.pad_trailing(linea.nombre, 16)}" <>
          "#{String.pad_leading("#{linea.prendas}", 7)} prendas | " <>
          "#{linea.puestos} puestos | " <>
          "#{Util.formatear_decimal(linea.productividad)} prendas/puesto"
      )
    end)
  end

  defp productividad(_prendas, puestos) when puestos <= 0, do: 0.0
  defp productividad(prendas, puestos), do: prendas / puestos

  # ---------------------------------------------------------------
  # R3. Producción diaria y meta
  # ---------------------------------------------------------------

  @doc "Mapa dia => prendas producidas por el taller. Los días sin lotes válidos valen cero."
  def produccion_diaria(lotes_validos) do
    por_dia = Util.prendas_por(lotes_validos, fn lote -> lote.dia end)

    Map.new(@dias_produccion, fn dia -> {dia, Map.get(por_dia, dia, 0)} end)
  end

  @doc "Indica si la meta se alcanzó todos los días y si se alcanzó al menos un día."
  def resumen_meta(produccion) do
    cumplidas = Enum.map(produccion, fn {_dia, prendas} -> meta_alcanzada?(prendas) end)

    %{todos: Enum.all?(cumplidas), alguno: Enum.any?(cumplidas)}
  end

  @doc "R3: imprime la producción de cada día y el cumplimiento de la meta."
  def imprimir_r3(lotes_validos) do
    produccion = produccion_diaria(lotes_validos)

    IO.puts("\n=== R3. Producción diaria del taller (meta: #{@meta_diaria} prendas) ===")

    produccion
    |> Enum.sort_by(fn {dia, _prendas} -> dia end)
    |> Enum.each(fn {dia, prendas} ->
      estado = if meta_alcanzada?(prendas), do: "meta alcanzada", else: "meta NO alcanzada"
      IO.puts("  Día #{dia}: #{prendas} prendas - #{estado}")
    end)

    resumen = resumen_meta(produccion)
    IO.puts("¿Se alcanzó la meta todos los días? #{Util.si_no(resumen.todos)}")
    IO.puts("¿Se alcanzó la meta al menos un día? #{Util.si_no(resumen.alguno)}")
  end

  defp meta_alcanzada?(prendas), do: prendas >= @meta_diaria

  # ---------------------------------------------------------------
  # R4. Liquidación de todos los confeccionistas (y C.1: ranking/2)
  # ---------------------------------------------------------------

  @doc """
  Ordena las liquidaciones según una keyword list de opciones.

  Devuelve `{:ok, lista}` o `{:error, motivo}` si alguna opción no es válida.
  Si una opción se repite, se usa la primera.
  """
  def ranking(liquidaciones, opciones) do
    campo = Keyword.get(opciones, :campo, :neto)
    orden = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite)

    with :ok <- validar_campo(campo),
         :ok <- validar_orden(orden),
         :ok <- validar_limite(limite) do
      ordenadas = Enum.sort_by(liquidaciones, fn liq -> Map.get(liq, campo, 0) end, orden)
      {:ok, aplicar_limite(ordenadas, limite)}
    end
  end

  defp validar_campo(campo) when campo in @campos_ranking, do: :ok
  defp validar_campo(_campo), do: {:error, :campo_invalido}

  defp validar_orden(orden) when orden in @ordenes_ranking, do: :ok
  defp validar_orden(_orden), do: {:error, :orden_invalido}

  defp validar_limite(nil), do: :ok
  defp validar_limite(limite) when is_integer(limite) and limite > 0, do: :ok
  defp validar_limite(_limite), do: {:error, :limite_invalido}

  defp aplicar_limite(lista, nil), do: lista
  defp aplicar_limite(lista, limite), do: Enum.take(lista, limite)

  @doc "Imprime el resultado de `ranking/2` con un título (para las llamadas de C.1 desde main)."
  def imprimir_ranking(titulo, {:ok, liquidaciones}) do
    IO.puts("\n--- #{titulo} ---")
    IO.puts(encabezado_liquidacion())

    liquidaciones
    |> Enum.with_index(1)
    |> Enum.each(fn {liq, posicion} -> IO.puts(fila_liquidacion(posicion, liq)) end)
  end

  def imprimir_ranking(titulo, {:error, motivo}) do
    IO.puts("\n--- #{titulo} ---")
    IO.puts("No se pudo generar el ranking: #{motivo}")
  end

  @doc "R4: imprime la liquidación numerada, de mayor a menor pago neto."
  def imprimir_r4(liquidaciones) do
    IO.puts("\n=== R4. Liquidación de confeccionistas ===")
    IO.puts(encabezado_liquidacion())

    liquidaciones
    |> Enum.sort_by(fn liq -> liq.neto end, :desc)
    |> Enum.with_index(1)
    |> Enum.each(fn {liq, posicion} -> IO.puts(fila_liquidacion(posicion, liq)) end)
  end

  defp encabezado_liquidacion do
    Enum.join(
      [
        String.pad_leading("#", 4),
        String.pad_trailing("Cód", 6),
        String.pad_trailing("Nombre", 22),
        String.pad_leading("Prendas", 8),
        String.pad_leading("Valor lotes", 16),
        String.pad_leading("Bonif.", 14),
        String.pad_leading("Alquiler", 14),
        String.pad_leading("Neto", 16)
      ],
      " "
    )
  end

  defp fila_liquidacion(posicion, liq) do
    Enum.join(
      [
        String.pad_leading("#{posicion}.", 4),
        String.pad_trailing(liq.codigo, 6),
        String.pad_trailing(liq.nombre, 22),
        String.pad_leading("#{liq.prendas}", 8),
        String.pad_leading(Util.formatear_dinero(liq.bruto), 16),
        String.pad_leading(Util.formatear_dinero(liq.bonificaciones), 14),
        String.pad_leading(Util.formatear_dinero(liq.alquiler), 14),
        String.pad_leading(Util.formatear_dinero(liq.neto), 16)
      ],
      " "
    )
  end

  # ---------------------------------------------------------------
  # R5. Confeccionista con más prendas cada día
  # ---------------------------------------------------------------

  @doc """
  Mapa dia => `{maximo_de_prendas, lista_de_codigos}`. Si hay empate la lista trae
  a todos los empatados; si el día no tiene lotes válidos, la lista es vacía.
  """
  def lideres_por_dia(lotes_validos) do
    por_dia = Enum.group_by(lotes_validos, fn lote -> lote.dia end)

    Map.new(@dias_produccion, fn dia ->
      {dia, lideres_del_dia(Map.get(por_dia, dia, []))}
    end)
  end

  defp lideres_del_dia([]), do: {0, []}

  defp lideres_del_dia(lotes_dia) do
    totales = Util.prendas_por(lotes_dia, fn lote -> lote.confeccionista end)
    maximo = totales |> Map.values() |> Enum.max()
    lideres = for {codigo, prendas} <- totales, prendas == maximo, do: codigo

    {maximo, Enum.sort(lideres)}
  end

  @doc """
  Quién ocupó el primer lugar más días. Devuelve `{dias, codigos}`;
  `{0, []}` si no hubo lotes válidos. En caso de empate incluye a todos.
  """
  def mas_dias_primero(lideres_por_dia) do
    conteo =
      lideres_por_dia
      |> Map.values()
      |> Enum.flat_map(fn {_maximo, lideres} -> lideres end)
      |> Enum.frequencies()

    case Map.values(conteo) do
      [] ->
        {0, []}

      cantidades ->
        maximo = Enum.max(cantidades)
        primeros = for {codigo, dias} <- conteo, dias == maximo, do: codigo
        {maximo, Enum.sort(primeros)}
    end
  end

  @doc "R5: imprime el líder de cada día y quién fue primero más veces."
  def imprimir_r5(lotes_validos, confeccionistas) do
    nombres = Util.nombres_por_codigo(confeccionistas)
    lideres = lideres_por_dia(lotes_validos)

    IO.puts("\n=== R5. Confeccionista con más prendas por día ===")

    lideres
    |> Enum.sort_by(fn {dia, _lideres_dia} -> dia end)
    |> Enum.each(fn {dia, lideres_dia} ->
      IO.puts(linea_lider(dia, lideres_dia, nombres))
    end)

    {dias, primeros} = mas_dias_primero(lideres)
    IO.puts(resumen_primer_lugar(dias, primeros, nombres))
  end

  defp linea_lider(dia, {_maximo, []}, _nombres), do: "  Día #{dia}: sin lotes válidos"

  defp linea_lider(dia, {maximo, lideres}, nombres) do
    empate = if length(lideres) > 1, do: " (empate)", else: ""
    quienes = Enum.map_join(lideres, ", ", fn codigo -> Util.etiqueta(codigo, nombres) end)

    "  Día #{dia}: #{quienes} con #{maximo} prendas#{empate}"
  end

  defp resumen_primer_lugar(_dias, [], _nombres) do
    "\nNingún confeccionista ocupó el primer lugar (no hay lotes válidos)."
  end

  defp resumen_primer_lugar(dias, primeros, nombres) do
    quienes = Enum.map_join(primeros, ", ", fn codigo -> Util.etiqueta(codigo, nombres) end)

    "\nMás días en primer lugar (#{dias}): #{quienes}"
  end

  # ---------------------------------------------------------------
  # R6. Mejor calidad (porcentaje de defectos ponderado por prendas)
  # ---------------------------------------------------------------

  def calidad_ponderada(lotes_validos) do
    lotes_validos
    |> Enum.group_by(fn lote -> lote.confeccionista end)
    |> Enum.filter(fn {_codigo, lotes} -> length(lotes) >= @minimo_lotes_calidad end)
    |> Enum.map(fn {codigo, lotes} ->
      total_prendas = lotes |> Enum.map(fn l -> l.prendas end) |> Enum.sum()
      suma_ponderada = lotes |> Enum.map(fn l -> l.defectos * l.prendas end) |> Enum.sum()
      suma_simple = lotes |> Enum.map(fn l -> l.defectos end) |> Enum.sum()

      %{
        codigo: codigo,
        lotes: length(lotes),
        prendas: total_prendas,
        ponderado: suma_ponderada / total_prendas,
        simple: suma_simple / length(lotes)
      }
    end)
  end

  @doc "Los confeccionistas con menor porcentaje ponderado (todos si hay empate). Lista vacía si nadie cumple el mínimo."
  def mejores_en_calidad(lotes_validos) do
    candidatos = calidad_ponderada(lotes_validos)

    case candidatos do
      [] ->
        []

      _ ->
        minimo = candidatos |> Enum.map(fn c -> c.ponderado end) |> Enum.min()
        Enum.filter(candidatos, fn c -> c.ponderado == minimo end)
    end
  end

  @doc "R6: imprime al confeccionista con mejor calidad."
  def imprimir_r6(lotes_validos, confeccionistas) do
    nombres = Util.nombres_por_codigo(confeccionistas)

    IO.puts("\n=== R6. Confeccionista con mejor calidad ===")

    case mejores_en_calidad(lotes_validos) do
      [] ->
        IO.puts("Ningún confeccionista tiene al menos #{@minimo_lotes_calidad} lotes válidos.")

      mejores ->
        Enum.each(mejores, fn mejor ->
          IO.puts(
            "  #{Util.etiqueta(mejor.codigo, nombres)}: " <>
              "#{Util.formatear_decimal(mejor.ponderado)} % de defectos ponderado " <>
              "(#{mejor.lotes} lotes, #{mejor.prendas} prendas; " <>
              "promedio simple: #{Util.formatear_decimal(mejor.simple)} %)"
          )
        end)
    end
  end

  # ---------------------------------------------------------------
  # R7. Total pagado y costo promedio por prenda
  # ---------------------------------------------------------------

  @doc """
  Total pagado por el taller y costo promedio por prenda válida.
  El promedio es `{:ok, valor}` o `{:error, :division_por_cero}` si no hay prendas válidas.
  """
  def resumen_pago(liquidaciones, lotes_validos) do
    total = liquidaciones |> Enum.map(fn liq -> liq.neto end) |> Enum.sum()
    prendas = lotes_validos |> Enum.map(fn lote -> lote.prendas end) |> Enum.sum()

    %{total: total, prendas: prendas, promedio: Util.dividir(total, prendas)}
  end

  @doc "R7: imprime el total pagado y el costo promedio por prenda."
  def imprimir_r7(liquidaciones, lotes_validos) do
    resumen = resumen_pago(liquidaciones, lotes_validos)

    IO.puts("\n=== R7. Total pagado y costo promedio por prenda ===")
    IO.puts("  Total a pagar en la semana: #{Util.formatear_dinero(resumen.total)}")
    IO.puts("  Prendas válidas: #{resumen.prendas}")

    case resumen.promedio do
      {:ok, promedio} ->
        IO.puts("  Costo promedio por prenda válida: #{Util.formatear_dinero(promedio)}")

      {:error, :division_por_cero} ->
        IO.puts("  El promedio no puede calcularse: no hay prendas válidas.")
    end
  end

  # ---------------------------------------------------------------
  # R8. Confeccionistas que trabajaron en todas las líneas
  # ---------------------------------------------------------------

  @doc "Códigos de los confeccionistas con al menos un lote válido en cada línea."
  def en_todas_las_lineas(lineas, lotes_validos) do
    ids_lineas = Enum.map(lineas, fn linea -> linea.id end)

    lotes_validos
    |> Enum.group_by(fn lote -> lote.confeccionista end, fn lote -> lote.linea end)
    |> Enum.filter(fn {_codigo, lineas_trabajadas} ->
      Enum.all?(ids_lineas, fn id -> id in lineas_trabajadas end)
    end)
    |> Enum.map(fn {codigo, _lineas} -> codigo end)
    |> Enum.sort()
  end

  @doc "R8: imprime quiénes trabajaron en todas las líneas."
  def imprimir_r8(lineas, lotes_validos, confeccionistas) do
    nombres = Util.nombres_por_codigo(confeccionistas)

    IO.puts("\n=== R8. Confeccionistas con lotes en todas las líneas ===")

    case en_todas_las_lineas(lineas, lotes_validos) do
      [] ->
        IO.puts("Ningún confeccionista trabajó en todas las líneas de producción.")

      codigos ->
        Enum.each(codigos, fn codigo -> IO.puts("  #{Util.etiqueta(codigo, nombres)}") end)
    end
  end

  # ---------------------------------------------------------------
  # C.2. Combinar la producción de dos talleres
  # ---------------------------------------------------------------

  @doc """
  Combina dos mapas dia => prendas sumando los días presentes en ambos.
  Los días que solo aparecen en uno de los mapas se conservan tal cual.
  """
  def combinar_produccion(produccion_a, produccion_b) do
    Map.merge(produccion_a, produccion_b, fn _dia, prendas_a, prendas_b ->
      prendas_a + prendas_b
    end)
  end
end
