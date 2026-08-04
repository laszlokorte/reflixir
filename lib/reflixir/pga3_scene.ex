defmodule Reflixir.PGA3Scene do
  alias Galixir.Algebras.PGA3
  defstruct [:points, :edges, :faces, :labels]

  def new(attrs) do
    struct(__MODULE__, attrs)
  end

  def new(p, e, f, l) do
    %__MODULE__{
      points: p,
      edges: e,
      faces: f,
      labels: l
    }
  end

  def to_svg(
        %__MODULE__{points: points, edges: edges, faces: faces, labels: labels},
        camera,
        opts \\ []
      ) do
    height = Keyword.get(opts, :height, 50)
    width = Keyword.get(opts, :width, 100)

    project = fn cam, p ->
      camera_point = PGA3.transform(p, cam)
      {x, y, z} = PGA3.point_coordinates(camera_point)
      screen_x = x * 100 / z
      screen_y = -y * 100 / z
      {screen_x, screen_y, z}
    end

    """
    <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="-100 -100 200 200"
    width="#{width}"
    height="#{height}"
    preserveAspectRatio="xMidYMid slice"
    >

      #{for {color, ps} <- faces do
      path = for p <- ps do
        {screen_x, screen_y, _} = project.(camera, p)
        "#{screen_x} #{screen_y}"
      end |> Enum.join(" ")
      """
        <polygon fill="#{color}"  points="#{path}"></polygon>
      """
    end |> Enum.join("\n")}

        #{for {{color, {p1, p2}}, i} <- edges |> Enum.with_index() do
      {screen1_x, screen1_y, z} = project.(camera, p1)
      {screen2_x, screen2_y, _} = project.(camera, p2)
      """
      <g>
        <line
        vector-effect="non-scaling-stroke"
        stroke-width="2"
        stroke-linecap="round"
        stroke="#{color}"
        x1="#{screen1_x}"
        y1="#{screen1_y}"
        x2="#{screen2_x}"
        y2="#{screen2_y}"></line>
        <text
          text-anchor="middle"
          dominant-baseline="central"
          visibility="hidden"
          fill="none"
          opacity="0.5"
          font-size="#{16 / abs(z)}"
          x="#{(screen1_x + screen2_x) / 2}"
          y="#{(screen1_y + screen2_y) / 2}">
          #{i}
          </text>
      </g>
      """
    end |> Enum.join("\n")}

    #{for {{color, p}, i} <- points |> Enum.with_index() do
      {screen_x, screen_y, z} = project.(camera, p)
      """
      <g>
        <circle fill="#{color}" r="#{10 / abs(z)}" cx="#{screen_x}" cy="#{screen_y}"></circle>
        <text
        text-anchor="middle"
        dominant-baseline="central"
        visibility="hidden"
        fill="none"
        opacity="0.5"
        font-size="#{16 / abs(z)}"
        x="#{screen_x}"
        y="#{screen_y}">#{i}</text>
      </g>
      """
    end |> Enum.join("\n")}
        #{for {color, p, l} <- labels do
      {screen_x, screen_y, _z} = project.(camera, p)
      """
        <text
        text-anchor="middle"
        dominant-baseline="central"
        fill="#{color}"
        font-size="#{3}"
        transform="translate(0, -5)"
        x="#{screen_x}"
        y="#{screen_y}">#{l}</text>
      """
    end |> Enum.join("\n")}
             <defs>
              <marker
                  id="vector-head"
                  viewBox="0 0 10 10"
                  refX="9"
                  refY="5"
                  markerWidth="10"
                  markerHeight="10"
                  fill="context-stroke"
                  orient="auto-start-reverse"
              >
                  <path d="M 10 5 l -10 5 l 3 -5 l -3 -5 z" />
              </marker>
          </defs>
      </svg>
    """
  end
end
