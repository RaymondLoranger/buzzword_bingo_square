import Config

config :buzzword_bingo_square,
  course_ref:
    """
    Based on the course [Multi-Player Bingo]
    (https://pragmaticstudio.com/courses/unpacked-bingo)\s
    by Mike and Nicole Clark.
    """
    |> String.replace("\n", "")
