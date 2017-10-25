module RazzleDazzle
  class Board
    attr_reader :counts
    def initialize(counts: default_counts)
      @counts = counts
    end

    def random_score
      # TODO: make the number of balls (8) configurable
      possible_scores.sample(8).inject(:+)
    end

    private

    def possible_scores
      @possible_scores ||= counts.map { |score, repeats| [score] * repeats }.flatten
    end

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

    def new_bet(current_bet)
      @change_bet_hook.call(current_bet)
    end
  end

  class ScoreActions
    attr_reader :point_actions
    def initialize(custom_point_actions = {})
      @point_actions = Hash.new(ScoreActionFactory.build)
        .merge(default_point_actions)
        .merge(custom_point_actions)
    end

    def new_score(previous_score, this_score)
      point_actions[this_score].new_score(previous_score)
    end

    def new_bet(score, current_bet)
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
        # Other rules could be used here, e.g. to DOUBLE the bet each time:
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
    attr_reader :score_actions, :target_score, :board
    def initialize(board: Board.new, score_actions: ScoreActions.new, target_score: 10, initial_bet: 1)
      @board = board
      @score_actions = score_actions
      @target_score = target_score
      @current_bet = initial_bet

      @current_score = 0
      @turns = 0
      @total_spend = 0
    end

    def play_until_win
      play_one_turn until won?
    end

    def play_one_turn
      self.turns += 1
      self.total_spend += current_bet

      score = board.random_score
      self.current_score = score_actions.new_score(current_score, score)
      self.current_bet = score_actions.new_bet(score, current_bet)
    end

    def won?
      current_score >= target_score
    end

    private

  end

  class Simulator
    attr_reader :game_template, :runs
    def initialize(game_template: Game.new, runs: 1)
      @game_template = game_template
      @runs = runs
    end

    def run
      (1..runs).each do |run_number|
        game = game_template.dup
        game.play_until_win
        puts "Simulation ##{run_number}/#{runs}:"
        puts "  Total turns: #{game.turns}"
        puts "  Total spend: #{game.total_spend}"
      end
    end
  end

end

# For example, try:
RazzleDazzle::Simulator.new(runs: 10).run
