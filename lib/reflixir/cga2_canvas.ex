defmodule Reflixir.CGA2Canvas do
  alias Galixir.Algebras.CGA2
  import CGA2

  def to_svg(shapes, opts \\ []) do
    thickness = Keyword.get(opts, :thickness, 1)
    {vx, vy, vw, vh} = Keyword.get(opts, :viewbox, {-50, -50, 100, 100})
    height = Keyword.get(opts, :height, vh)
    width = Keyword.get(opts, :width, vw)

    """
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="#{vx} #{vy} #{vw} #{vh}" width="#{width}" height="#{height}">
    <defs>
              <marker
                  id="vector-head"
                  viewBox="0 0 10 10"
                  refX="9"
                  refY="5"
                  markerWidth="20"
                  markerHeight="20"
                  fill="context-stroke"
                  orient="auto-start-reverse"
              >
                  <path d="M 10 5 l -10 5 l 3 -5 l -3 -5 z" />
              </marker>
          </defs>
    <line marker-end="url(#vector-head)" x1="#{vx}" y1="0" x2="#{vx + vw}" y2="0" stroke-width="#{thickness / 2}" stroke="black" vector-effect="non-scaling-stroke" />
    <line marker-end="url(#vector-head)" y2="#{vy}" x1="0" y1="#{vy + vh}" x2="0" stroke-width="#{thickness / 2}" stroke="black" vector-effect="non-scaling-stroke" />

      #{for {color, s} <- shapes do
      classify(s) |> case do
        {:circle, {{cx, cy}, r}} -> """
          <circle
            cx="#{cx}"
            cy="#{-cy}"
            r="#{r}"
            fill="#{color}"
          fill-opacity="0.1"
            stroke="#{color}"
            stroke-width="#{thickness}">
          <title>Circle #{inspect(s)}</title>
          </circle>
          """
        {:point, {cx, cy}} -> """
          <circle
            cx="#{cx}"
            cy="#{-cy}"
            r="#{thickness + 0.5}"
            fill="#{color}"
            stroke="none"
            stroke-width="1">
          <title>Point #{inspect(s)}</title>
          </circle>
          """
        {:point_pair, kind, {{cx1, cy1}, {cx2, cy2}}} -> rad = if(kind == :real, do: 0.5, else: 1) + thickness / 2

          {c1, c2} = color |> case do
            {a, b} -> {a, b}
            c when is_atom(c) or is_binary(c) -> {c, "white"}
            c -> {c, c}
          end
          dash = rad * 3.141 / 6
          stroke = 2 + thickness / 2 - rad
          stroke2 = if(kind == :real, do: stroke, else: stroke / 2)
          """
          <g>
          <circle
            cx="#{cx1}"
            cy="#{-cy1}"
            r="#{rad}"
            stroke="#{c1}"
            fill="#{c2}"
            stroke-dasharray="#{dash} #{dash}"
            stroke-width="#{stroke}"/>
          <circle
            cx="#{cx1}"
            cy="#{-cy1}"
            r="#{rad}"
            stroke="#{c2}"
            fill="none"
            stroke-dasharray="#{dash} #{dash}"
            stroke-dashoffset="#{dash}"
            stroke-width="#{stroke2}" />
          <title>Point Pair (1/2) #{inspect(s)}</title>
          </g>
          <g>
          <circle
            cx="#{cx2}"
            cy="#{-cy2}"
            r="#{rad}"
          fill="#{c1}"
          stroke-dasharray="#{dash} #{dash}"
          stroke-dashoffset="#{dash}"
            stroke="#{c1}"
            stroke-width="#{stroke}"/>

          <circle
            cx="#{cx2}"
            cy="#{-cy2}"
            r="#{rad}"
            fill="none"
          stroke-dasharray="#{dash} #{dash}"
            stroke="#{c2}"
            stroke-width="#{stroke2}" />
          <title>Point Pair (2/2) #{inspect(s)}</title>
          </g>
          """
        _ -> ""
      end
    end}

    </svg>
    <style>
    svg {
    padding: 1em;
    display: block;
    width: 100%;
    height: auto;
    box-sizing: border-box;
    }
    </style>
    """
    |> Kino.HTML.new()
  end
end
