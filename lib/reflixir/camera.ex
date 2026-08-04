defmodule Camera do
  alias Galixir.Algebras.PGA3

  def look_at(
        %{
          yaw: yaw,
          pitch: pitch,
          radius: radius,
          roll: roll
        },
        %{x: fx, y: fy, z: fz}
      ) do
    target = PGA3.point(fx, fy, fz)
    eye = eye(pitch, yaw, radius) |> PGA3.add(target)
    pole = PGA3.ideal_point(0, :math.sin(roll), :math.cos(roll))

    Reflixir.Utils.look_at(eye, target, pole)
  end

  def eye(pitch, yaw, radius) do
    PGA3.point(
      radius * :math.cos(pitch) * :math.cos(yaw),
      radius * :math.cos(pitch) * :math.sin(yaw),
      radius * :math.sin(pitch)
    )
  end
end
