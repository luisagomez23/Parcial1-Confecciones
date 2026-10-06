# Parcial 1 - Programación III - Universidad del Quindío
# Integrantes: Luisa Gómez, Juan Camilo Gordillo, Juan Esteban Mejia
defmodule Datos do
  @moduledoc """
  Datos del taller de confección: 10 confeccionistas, 4 líneas y 90 lotes
  (80 válidos y 10 inválidos).
  """

  @doc """
  Lista de confeccionistas.
  """
  def confeccionistas do
    [
      %{codigo: "C01", nombre: "María Elena Ríos", alquiler: true},
      %{codigo: "C02", nombre: "Andrés Salazar", alquiler: false},
      %{codigo: "C03", nombre: "Luisa Fernanda Gómez", alquiler: true},
      %{codigo: "C04", nombre: "Carlos Mario Londoño", alquiler: false},
      %{codigo: "C05", nombre: "Diana Patricia Herrera", alquiler: true},
      %{codigo: "C06", nombre: "Juan Esteban Ospina", alquiler: false},
      %{codigo: "C07", nombre: "Paola Andrea Cardona", alquiler: true},
      %{codigo: "C08", nombre: "Sebastián Quintero", alquiler: false},
      %{codigo: "C09", nombre: "Marta Lucía Giraldo", alquiler: true},
      %{codigo: "C10", nombre: "Hernán Darío Vélez", alquiler: false}

    ]
  end

  @doc """
  Lista de líneas de producción.
  """
  def lineas do
    [
      %{id: "L1", nombre: "Línea Norte", puestos: 6},
      %{id: "L2", nombre: "Línea Central", puestos: 4},
      %{id: "L3", nombre: "Línea Sur", puestos: 5},
      %{id: "L4", nombre: "Línea Acabados", puestos: 3}

    ]
  end

  @doc """
  Lista de lotes registrados (válidos e inválidos).
  """
  def lotes do
    [
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1, prendas: 55, defectos: 7},
      %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 90, defectos: 12},
      %{confeccionista: "C05", linea: "L1", dia: 2, prendas: 8, defectos: 20},
      %{confeccionista: "C05", linea: "L2", dia: 4, prendas: 120, defectos: 1},
      %{confeccionista: "C05", linea: "L3", dia: 5, prendas: 100, defectos: 2},
      %{confeccionista: "C05", linea: "L4", dia: 4, prendas: 70, defectos: 10},
      %{confeccionista: "C05", linea: "L1", dia: 6, prendas: 85, defectos: 2},
      %{confeccionista: "C05", linea: "L2", dia: 4, prendas: 30, defectos: 5},
      %{confeccionista: "C05", linea: "L3", dia: 4, prendas: 70, defectos: 15},
      %{confeccionista: "C05", linea: "L4", dia: 4, prendas: 65, defectos: 10},
      %{confeccionista: "C05", linea: "L1", dia: 1, prendas: 50, defectos: 8},
      %{confeccionista: "C05", linea: "L2", dia: 3, prendas: 55, defectos: 5},
      %{confeccionista: "C02", linea: "L1", dia: 1, prendas: 60, defectos: 1.5},
      %{confeccionista: "C02", linea: "L2", dia: 4, prendas: 40, defectos: 0.5},
      %{confeccionista: "C02", linea: "L1", dia: 5, prendas: 65, defectos: 1.5},
      %{confeccionista: "C02", linea: "L2", dia: 6, prendas: 45, defectos: 7},
      %{confeccionista: "C02", linea: "L1", dia: 4, prendas: 55, defectos: 1},
      %{confeccionista: "C02", linea: "L1", dia: 3, prendas: 40, defectos: 6},
      %{confeccionista: "C02", linea: "L2", dia: 4, prendas: 110, defectos: 9},
      %{confeccionista: "C02", linea: "L2", dia: 4, prendas: 40, defectos: 3},
      %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 85, defectos: 6},
      %{confeccionista: "C02", linea: "L2", dia: 1, prendas: 65, defectos: 5},
      %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 55, defectos: 0.5},
      %{confeccionista: "C02", linea: "L2", dia: 5, prendas: 95, defectos: 1},
      %{confeccionista: "C03", linea: "L1", dia: 3, prendas: 65, defectos: 7},
      %{confeccionista: "C03", linea: "L2", dia: 1, prendas: 60, defectos: 12},
      %{confeccionista: "C03", linea: "L3", dia: 1, prendas: 65, defectos: 2.5},
      %{confeccionista: "C03", linea: "L4", dia: 1, prendas: 70, defectos: 1},
      %{confeccionista: "C03", linea: "L4", dia: 2, prendas: 85, defectos: 12},
      %{confeccionista: "C03", linea: "L1", dia: 3, prendas: 85, defectos: 3},
      %{confeccionista: "C03", linea: "L3", dia: 2, prendas: 110, defectos: 9},
      %{confeccionista: "C03", linea: "L2", dia: 6, prendas: 55, defectos: 8},
      %{confeccionista: "C03", linea: "L3", dia: 1, prendas: 65, defectos: 12},
      %{confeccionista: "C03", linea: "L1", dia: 6, prendas: 80, defectos: 2.5},
      %{confeccionista: "C03", linea: "L2", dia: 5, prendas: 35, defectos: 3.5},
      %{confeccionista: "C04", linea: "L4", dia: 1, prendas: 85, defectos: 10},
      %{confeccionista: "C04", linea: "L4", dia: 1, prendas: 80, defectos: 4},
      %{confeccionista: "C04", linea: "L4", dia: 1, prendas: 110, defectos: 9},
      %{confeccionista: "C04", linea: "L4", dia: 2, prendas: 100, defectos: 2.5},
      %{confeccionista: "C04", linea: "L3", dia: 2, prendas: 35, defectos: 4},
      %{confeccionista: "C04", linea: "L3", dia: 6, prendas: 100, defectos: 3},
      %{confeccionista: "C04", linea: "L4", dia: 2, prendas: 70, defectos: 0.5},
      %{confeccionista: "C04", linea: "L4", dia: 1, prendas: 30, defectos: 2},
      %{confeccionista: "C04", linea: "L4", dia: 6, prendas: 95, defectos: 2},
      %{confeccionista: "C04", linea: "L2", dia: 1, prendas: 110, defectos: 1},
      %{confeccionista: "C04", linea: "L4", dia: 4, prendas: 70, defectos: 1},
      %{confeccionista: "C06", linea: "L3", dia: 3, prendas: 40, defectos: 6},
      %{confeccionista: "C06", linea: "L1", dia: 4, prendas: 85, defectos: 5},
      %{confeccionista: "C06", linea: "L4", dia: 4, prendas: 55, defectos: 0.5},
      %{confeccionista: "C06", linea: "L4", dia: 4, prendas: 30, defectos: 1},
      %{confeccionista: "C06", linea: "L1", dia: 6, prendas: 60, defectos: 6},
      %{confeccionista: "C06", linea: "L1", dia: 4, prendas: 60, defectos: 4.5},
      %{confeccionista: "C06", linea: "L3", dia: 6, prendas: 110, defectos: 12},
      %{confeccionista: "C06", linea: "L4", dia: 1, prendas: 90, defectos: 11},
      %{confeccionista: "C06", linea: "L1", dia: 1, prendas: 85, defectos: 5},
      %{confeccionista: "C06", linea: "L1", dia: 4, prendas: 50, defectos: 1.5},
      %{confeccionista: "C06", linea: "L4", dia: 2, prendas: 55, defectos: 15},
      %{confeccionista: "C07", linea: "L1", dia: 6, prendas: 110, defectos: 2.5},
      %{confeccionista: "C07", linea: "L2", dia: 1, prendas: 110, defectos: 12},
      %{confeccionista: "C07", linea: "L3", dia: 3, prendas: 55, defectos: 1},
      %{confeccionista: "C07", linea: "L4", dia: 4, prendas: 80, defectos: 8},
      %{confeccionista: "C07", linea: "L2", dia: 6, prendas: 45, defectos: 3.5},
      %{confeccionista: "C07", linea: "L1", dia: 6, prendas: 85, defectos: 4},
      %{confeccionista: "C07", linea: "L2", dia: 4, prendas: 75, defectos: 3.5},
      %{confeccionista: "C07", linea: "L2", dia: 3, prendas: 80, defectos: 2.5},
      %{confeccionista: "C07", linea: "L4", dia: 2, prendas: 65, defectos: 8},
      %{confeccionista: "C07", linea: "L4", dia: 5, prendas: 35, defectos: 3.5},
      %{confeccionista: "C07", linea: "L4", dia: 4, prendas: 90, defectos: 10},
      %{confeccionista: "C08", linea: "L3", dia: 4, prendas: 45, defectos: 10},
      %{confeccionista: "C08", linea: "L3", dia: 2, prendas: 30, defectos: 5},
      %{confeccionista: "C08", linea: "L3", dia: 6, prendas: 75, defectos: 2.5},
      %{confeccionista: "C08", linea: "L2", dia: 3, prendas: 50, defectos: 4},
      %{confeccionista: "C08", linea: "L3", dia: 1, prendas: 85, defectos: 4.5},
      %{confeccionista: "C08", linea: "L3", dia: 6, prendas: 75, defectos: 6},
      %{confeccionista: "C08", linea: "L3", dia: 1, prendas: 70, defectos: 15},
      %{confeccionista: "C08", linea: "L2", dia: 6, prendas: 90, defectos: 7},
      %{confeccionista: "C08", linea: "L3", dia: 4, prendas: 70, defectos: 5},
      %{confeccionista: "C09", linea: "L4", dia: 5, prendas: 110, defectos: 6},
      %{confeccionista: "C09", linea: "L4", dia: 5, prendas: 55, defectos: 2.5},
      # 10 lotes inválidos (2 por cada motivo)
      # :confeccionista_desconocido (el primero también tiene día inválido: solo se informa el primer motivo)
      %{confeccionista: "C99", linea: "L1", dia: 9, prendas: 60, defectos: 3},
      %{confeccionista: "C77", linea: "L3", dia: 5, prendas: 45, defectos: 1.5},
      # :linea_desconocida (el primero también tiene prendas inválidas)
      %{confeccionista: "C10", linea: "L9", dia: 1, prendas: 500, defectos: 2},
      %{confeccionista: "C04", linea: "L7", dia: 3, prendas: 80, defectos: 4},
      # :dia_invalido
      %{confeccionista: "C03", linea: "L2", dia: 7, prendas: 60, defectos: 2},
      %{confeccionista: "C06", linea: "L1", dia: 0, prendas: 40, defectos: 5},
      # :prendas_fuera_de_rango
      %{confeccionista: "C02", linea: "L2", dia: 3, prendas: 0, defectos: 2.5},
      %{confeccionista: "C08", linea: "L4", dia: 4, prendas: 200, defectos: 6},
      # :porcentaje_invalido
      %{confeccionista: "C07", linea: "L3", dia: 6, prendas: 70, defectos: -3},
      %{confeccionista: "C09", linea: "L1", dia: 2, prendas: 35, defectos: 104.5}

    ]
  end
end
