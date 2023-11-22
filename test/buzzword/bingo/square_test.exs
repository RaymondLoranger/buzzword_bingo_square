defmodule Buzzword.Bingo.SquareTest do
  use ExUnit.Case, async: true

  alias Buzzword.Bingo.{Player, Square}

  doctest Square

  describe "Square.new/2" do
    test "returns a square struct" do
      assert(
        Square.new("Win-Win", 350) == %Square{phrase: "Win-Win", points: 350}
      )
    end

    test "returns a square struct in a `with` macro" do
      assert(
        with %Square{} = square <- Square.new("Going Forward", 500) do
          square
        end == %Square{phrase: "Going Forward", points: 500}
      )
    end

    test "returns an error tuple" do
      assert Square.new(~c"Game Plan", 400) == {:error, :invalid_square_args}
    end

    test "returns an error tuple in a `with` macro" do
      assert(
        with %Square{} = square <- Square.new(~c"Game Plan", 400) do
          square
        else
          error -> error
        end == {:error, :invalid_square_args}
      )
    end
  end

  describe "Square.new/1" do
    test "returns a square struct" do
      assert(
        Square.new({"Upsell", 225}) == %Square{phrase: "Upsell", points: 225}
      )
    end

    test "returns an error tuple" do
      assert Square.new({~c"Upsell", 225}) == {:error, :invalid_square_args}
    end
  end

  describe "Square.mark/3" do
    test "returns a new square struct" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")

      assert(
        Square.mark(square, "Bottom Line", arthur) == %Square{
          phrase: "Bottom Line",
          points: 375,
          marked_by: arthur
        }
      )
    end

    test "returns the same square struct when phrase unmatched" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")
      assert ^square = Square.mark(square, ~c"Bottom Line", arthur)
    end

    test "returns the same square struct when already marked" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")
      arnold = Player.new("Arnold", "light_yellow")
      square = Square.mark(square, "Bottom Line", arthur)
      assert ^square = Square.mark(square, "Bottom Line", arnold)
    end

    test "can be encoded by Jason" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")
      marked = Square.mark(square, "Bottom Line", arthur)

      assert Jason.encode!(marked) ==
               ~s<{"marked_by":{"color":"green_yellow","name":"Arthur"},"phrase":"Bottom Line","points":375}>
    end
  end
end
