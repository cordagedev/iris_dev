defmodule Iris.MixProject do
  use Mix.Project

  def project do
    [
      app: :iris,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
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
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.3"},
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "iris_test",
      description: "Iris is the library that provides http request interface",
      organization: "hexpm",
      licenses: ["MPL-2.0"],
      links: %{
        "Changelog" => "https://hexdocs.pm/iris_test/changelog.html"
      },
      files: ~w(lib mix.exs .formatter.exs README.md config)
    ]
  end
end
