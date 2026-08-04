# Reflixir

Helper package to render Galixir Geometric Algebra objects in Livebook

## Installation

```elixir
def deps do
  [
    {:reflixir, "~> 0.1.0"}
  ]
end
```

## Example

Take a look at the [example LiveBook](./guides/example.livemd)

### CGA 2D

```elixir
alias Galixir.Algebras.CGA2

# create some 2d points
p0 = CGA2.point(10, 4)
p1 = CGA2.point(10, 15)
p2 = CGA2.point(0, 10)

# create some circles from a centere and radius
c1 = CGA2.circle(p0, 15)
c2 = CGA2.circle(p2, 10)
c3 = CGA2.circle(p1, 25)

# some more points
p4 = CGA2.point(50, 8)
p5 = CGA2.point(43, 20)
p6 = CGA2.point(60, 10)

# circle through 3 points
cc = CGA2.wedge(p4, p5) |> CGA2.wedge(p6)

# assign color to each object to render them on an SVG canvas
[
  {:blue, c1},
  {:green, c2},
  {:green, p2},
  {:orange, c3},
  {:orange, p1},
  {:blue, p0},
  {:hotpink, cc},
  {:purple, p4},
  {:purple, p5},
  {:purple, p6},
  {{:orange, :green}, CGA2.meet(c2, c3)},
  {{:blue, :green}, CGA2.meet(c1, c2)},
  {{:blue, :orange}, CGA2.meet(c1, c3)},
  {:green, CGA2.wedge(CGA2.point(20, 10), CGA2.point(10, -20))},
  {:magenta, CGA2.point(60, -16)}
]
|> Reflixir.CGA2Canvas.to_svg(
  thickness: 1,
  height: 40,
  width: 90,
  viewbox: {-100, -50, 200, 100}
)
```

### PGA 3D

```elixir
Reflixir.PGA3Screen.new(%{height: 3, width: 1}, fn %{height: h, width: w} ->
  pyramid_tip = PGA3.point(0, 0, h)

  Reflixir.PGA3Scene.new(
    points: [
      {"rebeccapurple", pyramid_tip},
      {"tomato", PGA3.point(w, w, 1)},
      {"tomato", PGA3.point(w, -w, 1)},
      {"tomato", PGA3.point(-w, -1, 1)},
      {"tomato", PGA3.point(-w, w, 1)},
      {"yellowgreen", PGA3.point(w, 0, 1)},
      {"yellowgreen", PGA3.point(-w, 0, 1)},
      {"yellowgreen", PGA3.point(0, -w, 1)},
      {"yellowgreen", PGA3.point(0, w, 1)},
      {"teal", PGA3.point(w, w, 0)},
      {"teal", PGA3.point(w, -w, 0)},
      {"teal", PGA3.point(-w, -w, 0)},
      {"teal", PGA3.point(-w, w, 0)}
    ],
    edges: [
      {"royalblue", {PGA3.point(w, w, 1), pyramid_tip}},
      {"royalblue", {PGA3.point(-w, w, 1), pyramid_tip}},
      {"royalblue", {PGA3.point(-w, -w, 1), pyramid_tip}},
      {"royalblue", {PGA3.point(w, -w, 1), pyramid_tip}},
      {"royalblue", {PGA3.point(w, w, 1), PGA3.point(-w, w, 1)}},
      {"royalblue", {PGA3.point(w, -w, 1), PGA3.point(-w, -w, 1)}},
      {"royalblue", {PGA3.point(-w, w, 1), PGA3.point(-w, -w, 1)}},
      {"royalblue", {PGA3.point(w, w, 1), PGA3.point(w, -w, 1)}},
      {"teal", {PGA3.point(w, w, 0), PGA3.point(-w, w, 0)}},
      {"teal", {PGA3.point(w, -w, 0), PGA3.point(-w, -w, 0)}},
      {"teal", {PGA3.point(-w, w, 0), PGA3.point(-w, -w, 0)}},
      {"teal", {PGA3.point(w, w, 0), PGA3.point(w, -w, 0)}},
      {"black", {PGA3.point(-5, 0, 0), PGA3.point(5, 0, 0)}},
      {"black", {PGA3.point(0, -5, 0), PGA3.point(0, 5, 0)}},
      {"black", {PGA3.point(0, 0, -3), PGA3.point(0, 0, 4)}}
    ],
    faces: [
      {"#4444",
       [
         PGA3.point(w, w, 0),
         PGA3.point(-w, w, 0),
         PGA3.point(-w, -w, 0),
         PGA3.point(w, -w, 0)
       ]},
      {"#5554",
       [
         PGA3.point(w, w, 1),
         PGA3.point(-w, w, 1),
         PGA3.point(-w, -w, 1),
         PGA3.point(w, -w, 1)
       ]},
      {"#0504",
       [
         PGA3.point(w, w, 1),
         PGA3.point(w, -w, 1),
         pyramid_tip
       ]},
      {"#5504",
       [
         PGA3.point(-w, w, 1),
         PGA3.point(-w, -w, 1),
         pyramid_tip
       ]},
      {"#0554",
       [
         PGA3.point(-w, -w, 1),
         PGA3.point(w, -w, 1),
         pyramid_tip
       ]},
      {"#5054",
       [
         PGA3.point(w, w, 1),
         PGA3.point(-w, w, 1),
         pyramid_tip
       ]}
    ],
    labels: [
      {"black", PGA3.point(5, 0, 0), "X"},
      {"black", PGA3.point(0, 5, 0), "Y"},
      {"black", PGA3.point(0, 0, 4), "Z"}
    ]
  )
end)
```

<svg viewBox="-100 -100 200 200" width="100" height="50" preserveAspectRatio="xMidYMid slice">
    <polygon fill="#4444" points="3.0559330780335583 16.844740567267888 -14.086362201597199 10.117665024529204 -2.6753206363765574 2.492770566012551 13.051204915887562 7.5433454284997055"></polygon>
<polygon fill="#5554" points="3.4026178069589164 7.18303741181369 -14.568239079276019 1.1319041976083204 -2.635559197675378 -5.563751614781501 13.78323596791483 -1.0709120411747461"></polygon>
<polygon fill="#0504" points="3.4026178069589164 7.18303741181369 13.78323596791483 -1.0709120411747461 0.36299355483977247 -20.201884860154752"></polygon>
<polygon fill="#5504" points="-14.568239079276019 1.1319041976083204 -2.635559197675378 -5.563751614781501 0.36299355483977247 -20.201884860154752"></polygon>
<polygon fill="#0554" points="-2.635559197675378 -5.563751614781501 13.78323596791483 -1.0709120411747461 0.36299355483977247 -20.201884860154752"></polygon>
<polygon fill="#5054" points="3.4026178069589164 7.18303741181369 -14.568239079276019 1.1319041976083204 0.36299355483977247 -20.201884860154752"></polygon>
      <line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="3.4026178069589164" y1="7.18303741181369" x2="0.36299355483977247" y2="-20.201884860154752"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.8759532729915658" x="1.8828056808993443" y="-6.5094237241705315">0</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="-14.568239079276019" y1="1.1319041976083204" x2="0.36299355483977247" y2="-20.201884860154752"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.6842766185962925" x="-7.1026227622181235" y="-9.534990331273216">1</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="-2.635559197675378" y1="-5.563751614781501" x2="0.36299355483977247" y2="-20.201884860154752"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.4530535556859978" x="-1.1362828214178027" y="-12.882818237468127">2</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="13.78323596791483" y1="-1.0709120411747461" x2="0.36299355483977247" y2="-20.201884860154752"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.5935201188713655" x="7.073114761377301" y="-10.63639845066475">3</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="3.4026178069589164" y1="7.18303741181369" x2="-14.568239079276019" y2="1.1319041976083204"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.8759532729915658" x="-5.582810636158551" y="4.157470804711005">4</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="13.78323596791483" y1="-1.0709120411747461" x2="-2.635559197675378" y2="-5.563751614781501"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.5935201188713655" x="5.573838385119727" y="-3.3173318279781236">5</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="-14.568239079276019" y1="1.1319041976083204" x2="-2.635559197675378" y2="-5.563751614781501"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.6842766185962925" x="-8.601899138475698" y="-2.2159237085865904">6</text>
<line stroke-width="2" stroke-linecap="round" stroke="royalblue" r="2" x1="3.4026178069589164" y1="7.18303741181369" x2="13.78323596791483" y2="-1.0709120411747461"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.8759532729915658" x="8.592926887436873" y="3.056062685319472">7</text>
<line stroke-width="2" stroke-linecap="round" stroke="teal" r="2" x1="3.0559330780335583" y1="16.844740567267888" x2="-14.086362201597199" y2="10.117665024529204"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.7840168061954673" x="-5.5152145617818205" y="13.481202795898547">8</text>
<line stroke-width="2" stroke-linecap="round" stroke="teal" r="2" x1="13.051204915887562" y1="7.5433454284997055" x2="-2.6753206363765574" y2="2.492770566012551"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.52668955331784" x="5.187942139755502" y="5.018057997256128">9</text>
<line stroke-width="2" stroke-linecap="round" stroke="teal" r="2" x1="-14.086362201597199" y1="10.117665024529204" x2="-2.6753206363765574" y2="2.492770566012551"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.609794714875268" x="-8.380841418986877" y="6.3052177952708774">10</text>
<line stroke-width="2" stroke-linecap="round" stroke="teal" r="2" x1="3.0559330780335583" y1="16.844740567267888" x2="13.051204915887562" y2="7.5433454284997055"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.7840168061954673" x="8.05356899696056" y="12.194042997883797">11</text>
<line stroke-width="2" stroke-linecap="round" stroke="black" r="2" x1="-33.24943124209666" y1="-2.8861582638671233" x2="53.56744329576665" y2="27.763617500353487"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.2661985187792675" x="10.159006026834994" y="12.438729618243181">12</text>
<line stroke-width="2" stroke-linecap="round" stroke="black" r="2" x1="19.430923791987176" y1="-6.450395321188764" x2="-42.77166998530122" y2="41.96408186955582"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.1437688075111392" x="-11.670373096657023" y="17.756843274183527">13</text>
<line stroke-width="2" stroke-linecap="round" stroke="black" r="2" x1="-0.5599124852725548" y1="31.16112506248814" x2="0.5728068661388837" y2="-31.87874330703157"></line>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.3878939013841514" x="0.00644719043316444" y="-0.35880912227171535">14</text>
<circle fill="rebeccapurple" r="1.1247216177869133" cx="0.36299355483977247" cy="-20.201884860154752"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.7995545884590611" x="0.36299355483977247" y="-20.201884860154752">0</text>
<circle fill="tomato" r="1.1724707956197287" cx="3.4026178069589164" cy="7.18303741181369"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.8759532729915658" x="3.4026178069589164" y="7.18303741181369">1</text>
<circle fill="tomato" r="0.9959500742946034" cx="13.78323596791483" cy="-1.0709120411747461"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.5935201188713655" x="13.78323596791483" y="-1.0709120411747461">2</text>
<circle fill="tomato" r="0.9081584723037486" cx="-2.635559197675378" cy="-5.563751614781501"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.4530535556859978" x="-2.635559197675378" y="-5.563751614781501">3</text>
<circle fill="tomato" r="1.0526728866226829" cx="-14.568239079276019" cy="1.1319041976083204"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.6842766185962925" x="-14.568239079276019" y="1.1319041976083204">4</text>
<circle fill="yellowgreen" r="1.0770255831856617" cx="9.015445004421476" cy="2.7201055075783813"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.7232409330970586" x="9.015445004421476" y="2.7201055075783813">5</text>
<circle fill="yellowgreen" r="0.9750902811695608" cx="-8.162176406458348" cy="-2.4626605770591756"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.5601444498712973" x="-8.162176406458348" y="-2.4626605770591756">6</text>
<circle fill="yellowgreen" r="0.9500303956704846" cx="5.195332565973552" cy="-3.4209061710373687"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.5200486330727756" x="5.195332565973552" y="-3.4209061710373687">7</text>
<circle fill="yellowgreen" r="1.1093469844266481" cx="-6.066570650183021" cy="3.9945795020258115"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.774955175082637" x="-6.066570650183021" y="3.9945795020258115">8</text>
<circle fill="teal" r="1.115010503872167" cx="3.0559330780335583" cy="16.844740567267888"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.7840168061954673" x="3.0559330780335583" y="16.844740567267888">9</text>
<circle fill="teal" r="0.9541809708236499" cx="13.051204915887562" cy="7.5433454284997055"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.52668955331784" x="13.051204915887562" y="7.5433454284997055">10</text>
<circle fill="teal" r="0.8732997234300838" cx="-2.6753206363765574" cy="2.492770566012551"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.397279557488134" x="-2.6753206363765574" y="2.492770566012551">11</text>
<circle fill="teal" r="1.0061216967970426" cx="-14.086362201597199" cy="10.117665024529204"></circle>
<text visibility="hidden" fill="none" opacity="0.5" font-size="1.609794714875268" x="-14.086362201597199" y="10.117665024529204">12</text>
<text fill="black" font-size="3" x="53.56744329576665" y="27.763617500353487">X</text>
<text fill="black" font-size="3" x="-42.77166998530122" y="41.96408186955582">Y</text>
<text fill="black" font-size="3" x="0.5728068661388837" y="-31.87874330703157">Z</text>
<defs>
          <marker id="vector-head" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="10" markerHeight="10" fill="context-stroke" orient="auto-start-reverse">
              <path d="M 10 5 l -10 5 l 3 -5 l -3 -5 z"></path>
          </marker>
      </defs>
  </svg>
