# ┌────────────────────────────────────────────────────────────────────┐
# │ Based on the course "Multi-Player Bingo" by Mike and Nicole Clark. │
# └────────────────────────────────────────────────────────────────────┘
defmodule Buzzword.Bingo.Square do
  @moduledoc """
  A square struct and functions for the _Multi-Player Buzzword Bingo_ game.

  The square struct contains the fields `phrase`, `points` and `marked_by`
  representing the properties of a square in the _Multi-Player Buzzword Bingo_
  game.

  ##### Based on the course [Multi-Player Bingo](https://pragmaticstudio.com/courses/unpacked-bingo) by Mike and Nicole Clark.
  """

  alias __MODULE__
  alias Buzzword.Bingo.Player
  alias Buzzword.Cache

  @derive JSON.Encoder
  @enforce_keys [:phrase, :points]
  defstruct [:phrase, :points, :marked_by]

  @typedoc "Square phrase"
  @type phrase :: String.t()
  @typedoc "Square points"
  @type points :: pos_integer
  @typedoc "A square struct for the Multi-Player Buzzword Bingo game"
  @type t :: %Square{
          phrase: phrase,
          points: points,
          marked_by: Player.t() | nil
        }

  @doc """
  Creates a square struct from the given `phrase` and `points`.

  ## Examples

      iex> alias Buzzword.Bingo.Square
      iex> Square.new("Bottom Line", 375)
      %Square{phrase: "Bottom Line", points: 375}

      iex> alias Buzzword.Bingo.Square
      iex> Square.new("Bottom Line", 0)
      {:error, :invalid_square_args}
  """
  @spec new(phrase, points) :: t | {:error, atom}
  def new(phrase, points)
      when is_binary(phrase) and is_integer(points) and points > 0 do
    %Square{phrase: phrase, points: points}
  end

  def new(_phrase, _points), do: {:error, :invalid_square_args}

  @doc """
  Creates a square struct from the given `buzzword`.

  ## Examples

      iex> alias Buzzword.Bingo.Square
      iex> Square.new({"Bottom Line", 375})
      %Square{phrase: "Bottom Line", points: 375}

      iex> alias Buzzword.Bingo.Square
      iex> Square.new({"Bottom Line", 0})
      {:error, :invalid_square_args}
  """
  @spec new(Cache.buzzword()) :: t | {:error, atom}
  def new({phrase, points} = _buzzword), do: new(phrase, points)

  @doc """
  Marks a virgin `square` having the given `phrase` with the given `player`.

  ## Examples

      iex> alias Buzzword.Bingo.{Player, Square}
      iex> square = Square.new("Bottom Line", 375)
      iex> arthur = Player.new("Arthur", "green_yellow")
      iex> Square.mark(square, "Bottom Line", arthur)
      %Square{
        phrase: "Bottom Line",
        points: 375,
        marked_by: %Player{name: "Arthur", color: "green_yellow"}
      }

      iex> alias Buzzword.Bingo.{Player, Square}
      iex> square = Square.new("Big Picture", 225)
      iex> arnold = Player.new("Arnold", "bright_turquoise")
      iex> Square.mark(square, "Best of Breed", arnold)
      %Square{phrase: "Big Picture", points: 225, marked_by: nil}

      iex> alias Buzzword.Bingo.{Player, Square}
      iex> square = Square.new("Best of Breed", 525)
      iex> joe = Player.new("Joe", "light_cyan")
      iex> jim = Player.new("Jim", "light_yellow")
      iex> square = Square.mark(square, "Best of Breed", joe)
      iex> Square.mark(square, "Best of Breed", jim)
      %Square{
        phrase: "Best of Breed",
        points: 525,
        marked_by: %Player{name: "Joe", color: "light_cyan"}
      }
  """
  @spec mark(t, phrase, Player.t()) :: t
  def mark(
        %Square{phrase: phrase, marked_by: nil} = square,
        phrase,
        %Player{} = player
      ) do
    put_in(square.marked_by, player)
  end

  def mark(%Square{} = square, _phrase, _player), do: square
end
