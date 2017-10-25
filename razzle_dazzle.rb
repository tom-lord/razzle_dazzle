module RazzleDazzle
  class Board
    attr_reader :counts
    def initialize(counts: default_counts)
      @counts = counts
    end

    def possible_scores
      @possible_scores ||= counts.map { |score, repeats| [score] * repeats }.flatten
    end

    private

    def default_counts
      {
        1 => 9,
        2 => 23,
        3 => 53,
        4 => 65,
        5 => 20,
        6 => 10
      }
    end
  end

  class Score
    attr_reader :points
    def initialize(points: default_points)
      @points = points
    end

    private

    def default_points
      {
        8 => 10,
        9 => 8,
        10 => 5,
        11 => 5,
        12 => 5,
        13 => 5,
        14 => 1.5,
        15 => 1.5,
        16 => 0.5,
        17 => 0.5,
        39 => 0.5,
        40 => 0.5,
        41 => 1.5,
        42 => 1.5,
        43 => 5,
        44 => 5,
        45 => 5,
        46 => 8,
        47 => 8,
        48 => 10
      }
    end
  end

  class Game
    def initialize(board: Board.new, score: Score.new)
      @board = board
      @score = score
      @current_score = 0
      @turns = 0
      @target_score = 10
    end

    def play
      while @current_score < @target_score do
        @turns += 1
        take_turn
      end  
    end

    def take_turn
      roll_results = roll
      roll_sum = roll_results.inject(:+)
      roll_score = @score.points[roll_sum].to_i
      @current_score += roll_score
      puts "Turn #{@turns} -- Rolled: #{roll_results}, total: #{roll_sum}, score: #{roll_score} -- total score: #{@current_score}"
    end

    def roll
      @board.possible_scores.sample(8)
    end

  end
end

# g = RazzleDazzle::Game.new
# g.play
