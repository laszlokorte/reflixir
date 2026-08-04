defmodule Reflixir.PGA3Screen do
  @behaviour Kino.Screen

  import Kino.Screen

  def new(
        %{} = scene_data,
        builder,
        %{
          eye: %{
            yaw: yaw,
            pitch: pitch,
            radius: radius,
            roll: roll
          },
          focus: %{x: fx, y: fy, z: fz}
        } \\ %{
          eye: %{
            yaw: 1,
            pitch: 0.5,
            radius: 20,
            roll: 0
          },
          focus: %{x: 0, y: 0, z: 1}
        }
      ) do
    state = %{
      cam: %{
        eye: %{
          yaw: yaw,
          pitch: pitch,
          radius: radius,
          roll: roll
        },
        focus: %{x: fx, y: fy, z: fz}
      },
      scene_data: scene_data,
      builder: builder
    }

    Kino.Screen.new(__MODULE__, state)
  end

  def render(%{
        cam: %{
          eye:
            eye = %{
              yaw: yaw,
              pitch: pitch,
              radius: radius,
              roll: roll
            },
          focus: %{x: fx, y: fy, z: fz} = focus
        },
        builder: builder,
        scene_data: sd
      }) do
    camera = Reflixir.Camera.look_at(eye, focus)

    [
      [
        Kino.Control.form(
          [
            yaw: Kino.Input.range("Yaw", min: -3.141, max: 3.141, default: yaw, step: 0.2),
            pitch:
              Kino.Input.range("Pitch",
                min: -3.141 / 2,
                max: 3.141 / 2,
                default: pitch,
                step: 0.1
              ),
            radius: Kino.Input.range("Radius", min: 1, max: 60, default: radius, step: 0.1),
            roll:
              Kino.Input.range("Roll", min: -3.141 / 2, max: 3.141 / 2, default: roll, step: 0.1)
          ],
          columns: 2,
          report_changes: true
        )
        |> control(&handle_camera/2),
        Kino.Control.form(
          [
            focus_x: Kino.Input.range("Focus X", min: -10, max: 10, default: fx, step: 0.1),
            focus_y: Kino.Input.range("Focus Y", min: -10, max: 10, default: fy, step: 0.1),
            focus_z: Kino.Input.range("Focus Z", min: -10, max: 10, default: fz, step: 0.1)
          ],
          columns: 2,
          report_changes: true
        )
        |> control(&handle_camera/2),
        Kino.Control.form(
          for {k, v} <- sd do
            {k, Kino.Input.range(Atom.to_string(k), min: 1, max: 5, default: v, step: 0.1)}
          end,
          columns: 2,
          report_changes: true
        )
        |> control(&handle_scene_data/2)
      ]
      |> Kino.Layout.grid(columns: 3),
      Kino.HTML.new("""
        #{Reflixir.PGA3Scene.to_svg(builder.(sd), camera)}

        <style>
          svg {
            font-family: monospace, monospace;
            text-anchor: middle;
            border: 2px solid #aaa;
            width: 100%;
            height: auto;
            box-sizing: border-box;
          }

          line {
            vector-effect: non-scaling-stroke;
          }

          line[stroke="black"] {
            stroke-width: 1;
            vector-effect: non-scaling-stroke;
            marker-end: url("#vector-head");
          }

          text {
            transform: translate(0, -5px);
          }
        </style>
      """)
    ]
    |> Kino.Layout.grid()
  end

  def handle_camera(
        %{
          data: %{
            yaw: yaw,
            pitch: pitch,
            radius: radius,
            roll: roll
          },
          type: :change
        },
        state
      ) do
    %{
      state
      | cam:
          Map.merge(state.cam, %{
            eye: %{
              yaw: yaw,
              pitch: pitch,
              radius: radius,
              roll: roll
            }
          })
    }
  end

  def handle_camera(
        %{
          data: %{
            focus_x: fx,
            focus_y: fy,
            focus_z: fz
          },
          type: :change
        },
        state
      ) do
    %{
      state
      | cam:
          Map.merge(state.cam, %{
            focus: %{x: fx, y: fy, z: fz}
          })
    }
  end

  def handle_scene_data(%{data: data, type: :change}, state) do
    %{state | scene_data: Map.merge(state.scene_data, data)}
  end
end
