require 'pry'
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

  class ScoreActionFactory
    def self.build(added_score: 0)
      new(added_score)
    end

    def initialize(added_score)
      @added_score = added_score
    end

    def added_score
      @added_score
    end
  end

  class ScoreActions
    attr_reader :point_actions
    def initialize(point_actions: default_point_actions)
      @point_actions = Hash.new(ScoreActionFactory.build).merge(point_actions)
    end

    def points_for(score)
      point_actions[score].added_score
    end

    private

    def default_point_actions
      {
        8 => ScoreActionFactory.build(added_score: 10),
        9 => ScoreActionFactory.build(added_score: 8),
        10 => ScoreActionFactory.build(added_score: 5),
        11 => ScoreActionFactory.build(added_score: 5),
        12 => ScoreActionFactory.build(added_score: 5),
        13 => ScoreActionFactory.build(added_score: 5),
        14 => ScoreActionFactory.build(added_score: 1.5),
        15 => ScoreActionFactory.build(added_score: 1.5),
        16 => ScoreActionFactory.build(added_score: 0.5),
        17 => ScoreActionFactory.build(added_score: 0.5),
        39 => ScoreActionFactory.build(added_score: 0.5),
        40 => ScoreActionFactory.build(added_score: 0.5),
        41 => ScoreActionFactory.build(added_score: 1.5),
        42 => ScoreActionFactory.build(added_score: 1.5),
        43 => ScoreActionFactory.build(added_score: 5),
        44 => ScoreActionFactory.build(added_score: 5),
        45 => ScoreActionFactory.build(added_score: 5),
        46 => ScoreActionFactory.build(added_score: 8),
        47 => ScoreActionFactory.build(added_score: 8),
        48 => ScoreActionFactory.build(added_score: 10)
      }
    end
  end

  class Game
    attr_accessor :turns
    def initialize(board: Board.new, score_actions: ScoreActions.new)
      @board = board
      @score_actions = score_actions
      @current_score = 0
      @turns = 0
      @target_score = 10
    end

    def play
      while @current_score < @target_score do
        self.turns += 1
        this_roll = roll_score
        @current_score += @score_actions.points_for(this_roll)
      end  
    end

    private

    def roll_score
      @board.possible_scores.sample(8).inject(:+)
    end
  end

  class Simulator
    def initialize(board: Board.new, score_actions: ScoreActions.new, runs: 1)
      @board = board
      @score_actions = score_actions
      @runs = runs
    end

    def run
      (1..@runs).each do |run_number|
        game = Game.new
        game.play
        puts "Simulation ##{run_number}/#{@runs}:"
        puts "  Total turns: #{game.turns}"
      end
    end
  end

end

RazzleDazzle::Simulator.new(runs: 10).run
