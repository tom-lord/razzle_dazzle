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
    class << self; alias_method :build, :new; end

    def initialize(added_score: 0, change_bet_hook: :itself.to_proc)
      @added_score = added_score
      @change_bet_hook = change_bet_hook
    end

    def new_score(score)
      score + @added_score
    end

    def new_bet(score)
      @change_bet_hook.call(score)
    end
  end

  class ScoreActions
    attr_reader :point_actions
    def initialize(point_actions: default_point_actions)
      @point_actions = Hash.new(ScoreActionFactory.build).merge(point_actions)
    end

    def new_score(previous_score, this_score)
      point_actions[this_score].new_score(previous_score)
    end

    def change_bet(score, current_bet)
      point_actions[score].new_bet(current_bet)
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
        # Other rules could be used here, e.g.
        # 29 => ScoreActionFactory.build(change_bet_hook: ->(bet){ bet * 2 }),
        29 => ScoreActionFactory.build(change_bet_hook: ->(bet){ bet + 1 }),
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
    attr_accessor :turns, :current_score, :current_bet, :total_spend
    attr_reader :score_actions, :target_score
    def initialize(board: Board.new, score_actions: ScoreActions.new, target_score: 10)
      @board = board
      @score_actions = score_actions
      @current_score = 0
      @turns = 0
      @target_score = target_score
      @current_bet = 1
      @total_spend = 0
    end

    def play
      while current_score < target_score do
        self.turns += 1
        this_roll = roll_score
        self.total_spend += current_bet
        self.current_score = score_actions.new_score(current_score, this_roll)
        self.current_bet = score_actions.change_bet(this_roll, current_bet)
      end  
    end

    private

    def roll_score
      @board.possible_scores.sample(8).inject(:+)
    end
  end

  class Simulator
    attr_reader :board, :score_actions, :runs
    def initialize(board: Board.new, score_actions: ScoreActions.new, runs: 1)
      @board = board
      @score_actions = score_actions
      @runs = runs
    end

    def run
      (1..runs).each do |run_number|
        game = Game.new(board: board, score_actions: score_actions)
        game.play
        puts "Simulation ##{run_number}/#{runs}:"
        puts "  Total turns: #{game.turns}"
        puts "  Total spend: #{game.total_spend}"
      end
    end
  end

end

RazzleDazzle::Simulator.new(runs: 10).run
