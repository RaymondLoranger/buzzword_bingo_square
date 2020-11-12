# ┌────────────────────────────────────────────────────────────────────┐
# │ Based on the course "Multi-Player Bingo" by Mike and Nicole Clark. │
# └────────────────────────────────────────────────────────────────────┘
defmodule Buzzword.Bingo.Square do
  @moduledoc """
  Creates a `square` struct for the _Multi-Player Bingo_ game.
  Also marks a virgin `square` having a given `phrase` for a given `player`.

  ##### Based on the course [Multi-Player Bingo](https://pragmaticstudio.com/courses/unpacked-bingo) by Mike and Nicole Clark.
  """

  alias __MODULE__
  alias Buzzword.Bingo.Player

  @derive [Poison.Encoder]
  @derive Jason.Encoder
  @enforce_keys [:phrase, :points]
  defstruct [:phrase, :points, :marked_by]

  @type t :: %Square{
          phrase: String.t(),
          points: pos_integer,
          marked_by: Player.t() | nil
        }

  @doc """
  Creates a `square` from the given `phrase` and `points`.

  ## Examples

      iex> alias Buzzword.Bingo.Square
      iex> Square.new("Bottom Line", 375)
      %Square{phrase: "Bottom Line", points: 375}

      iex> alias Buzzword.Bingo.Square
      iex> Square.new("Bottom Line", 0)
      {:error, :invalid_square_args}
  """
  @spec new(String.t(), pos_integer) :: t | {:error, atom}
  def new(phrase, points)
      when is_binary(phrase) and is_integer(points) and points > 0 do
    %Square{phrase: phrase, points: points}
  end

  def new(_phrase, _points), do: {:error, :invalid_square_args}

  @doc """
  Creates a `square` from the given `buzzword`.

  ## Examples

      iex> alias Buzzword.Bingo.Square
      iex> Square.new({"Bottom Line", 375})
      %Square{phrase: "Bottom Line", points: 375}

      iex> alias Buzzword.Bingo.Square
      iex> Square.new({"Bottom Line", 0})
      {:error, :invalid_square_args}
  """
  @spec new({phrase :: String.t(), points :: pos_integer}) :: t | {:error, atom}
  def new({phrase, points} = _buzzword), do: new(phrase, points)

  @doc """
  Marks a virgin `square` having the given `phrase` for the given `player`.

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
  @spec mark(t, String.t(), Player.t()) :: t
  def mark(
        %Square{phrase: phrase, marked_by: nil} = square,
        phrase,
        %Player{} = player
      ) do
    put_in(square.marked_by, player)
  end

  def mark(%Square{} = square, _phrase, _player), do: square
end
