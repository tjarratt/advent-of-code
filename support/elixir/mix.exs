defmodule AocSupport.MixProject do
  use Mix.Project

  @github_url "https://github.com/tjarratt/advent-of-code"

  def project do
    [
      app: :aoc_support,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package() do
    [
      files: ~w[
        README.*
        lib
        LICENSE
        mix.exs
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url},
      maintainers: ["Tim Jarratt"]
    ]
  end
end
