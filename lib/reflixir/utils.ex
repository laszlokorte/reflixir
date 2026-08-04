defmodule Reflixir.Utils do
  import Galixir.Algebras.PGA3

  def look_at(
        position \\ point(0, 10, 0),
        target \\ point(0, 0, 0),
        pole \\ ideal_point(0, 0, 1)
      ) do
    align(
      [position, target, pole],
      [point(0, 0, 0), point(0, 0, 1), ideal_point(0, 1, 0)]
    )
  end
end
