defmodule Buzzword.Bingo.SquareTest do
  use ExUnit.Case, async: true

  alias Buzzword.Bingo.{Player, Square}

  doctest Square

  describe "Square.new/2" do
    test "returns a struct" do
      assert(
        Square.new("Win-Win", 350) == %Square{phrase: "Win-Win", points: 350}
      )
    end

    test "returns a struct in a `with` macro" do
      assert(
        with %Square{} = square <- Square.new("Going Forward", 500) do
          square
        end == %Square{phrase: "Going Forward", points: 500}
      )
    end

    test "returns a tuple" do
      assert Square.new('Game Plan', 400) == {:error, :invalid_square_args}
    end

    test "returns a tuple in a `with` macro" do
      assert(
        with %Square{} = square <- Square.new('Game Plan', 400) do
          square
        else
          error -> error
        end == {:error, :invalid_square_args}
      )
    end
  end

  describe "Square.new/1" do
    test "returns a struct" do
      assert(
        Square.new({"Upsell", 225}) == %Square{phrase: "Upsell", points: 225}
      )
    end

    test "returns a tuple" do
      assert Square.new({'Upsell', 225}) == {:error, :invalid_square_args}
    end
  end

  describe "Square.mark/3" do
    test "returns a new struct" do
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

    test "returns the same struct" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")
      assert ^square = Square.mark(square, 'Bottom Line', arthur)
    end

    test "returns the same struct when marked" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")
      arnold = Player.new("Arnold", "light_yellow")
      square = Square.mark(square, "Bottom Line", arthur)
      assert ^square = Square.mark(square, "Bottom Line", arnold)
    end

    test "can be encoded by Poison" do
      square = Square.new("Bottom Line", 375)
      arthur = Player.new("Arthur", "green_yellow")
      marked = Square.mark(square, "Bottom Line", arthur)

      assert Poison.encode!(marked) ==
               ~s<{"points":375,"phrase":"Bottom Line","marked_by":{"name":"Arthur","color":"green_yellow"}}>
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
