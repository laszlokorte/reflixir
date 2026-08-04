defmodule Reflixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :reflixir,
      version: "0.3.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/laszlokorte/reflixir",
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp package() do
    %{
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/laszlokorte/reflixir"}
    }
  end

  defp description() do
    "Helper package to render Galixir Geometric Algebra objects in Livebook"
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:galixir, "~> 0.28"},
      {:kino, "~> 0.19"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
