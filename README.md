## Razzle Dazzle

A flexible simulation for the [razzle dazzle game](http://www.goodmagic.com/websales/midway/razzle.htm).

[This youtube video](https://www.youtube.com/watch?v=KaIZl0H2yNE) does a good job
of explaining the game rules, and how scam artists manipulate players.

This code is designed to simulate a real game - so you can play under whatever "rules"
you like, without spending a penny!

## Usage

By default, the simulator will run with a set of "standard" game rules, as desribed below:

```ruby
RazzleDazzle::Simulator.new(runs: 10).run

Simulation #1/10:
  Total turns: 18752
  Total spend: 20966989
Simulation #2/10:
  Total turns: 15941
  Total spend: 14806222
Simulation #3/10:
  Total turns: 17780
  Total spend: 19139481
Simulation #4/10:
  Total turns: 16992
  Total spend: 17573584
Simulation #5/10:
  Total turns: 20145
  Total spend: 24383806
Simulation #6/10:
  Total turns: 30463
  Total spend: 56773254
Simulation #7/10:
  Total turns: 18250
  Total spend: 20321705
Simulation #8/10:
  Total turns: 20258
  Total spend: 23007123
Simulation #9/10:
  Total turns: 22560
  Total spend: 30454038
Simulation #10/10:
  Total turns: 13094
  Total spend: 10019937
```

You can also provide custom game rules. For example, to make the price-per-play **double**
each time you score 29:

```ruby
RazzleDazzle::Simulator.new(
  game_template: RazzleDazzle::Game.new(
    score_actions: RazzleDazzle::ScoreActions.new(
      29 => RazzleDazzle::ScoreActionFactory.build(change_bet_hook: ->(bet){ bet * 2 })
    )
  )
).run

Simulation #1/1:
  Total turns: 21334
  Total spend: 176813501366417026593975950893702581934582288129535091895011404289310363375791292195401207467744639191971217201685582550601832440751248325303703971280614900822845009669773925571632215545486020001834600598840050354009827663068621112829655386332983243089793175291419203957832046216447072853592422878523809980893290444746232237957216596660091104125566374312955977808849387900508051149474197256854247190190296473483866865759777066523460878061582008001477551586063408806355263035466158851729461821029004988220800718249342215262038934964543768037328633606059342234291611733892801133577851057649322733605106873671109365359157165993655830630413719952597492276565067433546050462347066264594179892197833795240867390438350479536643383162604118795279888714864009070363722827
```

(Yes, my result really was that big!! That's about `1.768 * 10^761`!)

You can also run an game manually, either one turn at a time or "until won":

```ruby
game = RazzleDazzle::Game.new

game.play_one_turn
puts game.current_score
puts game.current_bet
puts game.total_spend
puts game.turns
puts game.total_spend

# This simply calls Game#play_one_turn repeatedly
# Depending on the rules, this will probably be a LOT of turns!!
game.play_until_win
```

### Configuration

You can simulate a number of Razzle Dazzle game runs, based on a set of _custom_ rules.

There are various defaults (discussed below), but you can provide a custom:

* `RazzleDazzle::Board` configuration (number of holes with each value).
* `RazzleDazzle::Score` mapping (actions to perform on each score, e.g.
"add 1 point", or "increase the price to play").

(There are undoubtedly *many more* variables that could be thrown in the mix,
such as 'randomly' awarding points, or giving free rolls, or giving mini-prizes,
... feel free to submit a PR!)

#### Default values

* There are **8** balls rolled each turn. This is _not yet configurable_.
* The initial bet-per-play is **1**. This can be configured like: `Game.new(initial_bet: 2)`
* The "winning score" is **10**. This can be configured like: `Game.new(target_score: 5)`
* The game board contains 180 scores, as taken from
[this image](http://www.goodmagic.com/websales/midway/photos/razzle2.jpg).
To summarise this, the number of occurances of each value is:

```ruby
{
  1 => 9,
  2 => 23,
  3 => 53,
  4 => 65,
  5 => 20,
  6 => 10
}
```

This can be configured like: `Game.new(board: Board.new({1 => 3, 2 => 7, ...}))`.

* Each game play score is taken from
[this image](http://www.goodmagic.com/websales/midway/photos/razzlechart.jpg).
(Note that the mysterious "H.P." squares are not currently programmed to mean
anything special...) To summarise this, the awarded scores are:

```ruby
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
```

These defaults can be overriden and/or added to, like:

```ruby
Game.new(
  score_actions: ScoreActions.new(
    17 => ScoreActionFactory.build(added_score: 1),
    18 => ScoreActionFactory.build(added_score: 0.5),
  )
)
```


* The special score of **29** (see the above board game image) is defined to
mean "increase your bet by 1".

Like above, this default can be overriden and/or added to, like:

```ruby
Game.new(
  score_actions: ScoreActions.new(
    29 => ScoreActionFactory.build(change_bet_hook: ->(bet){ bet * 2 }),
    30 => ScoreActionFactory.build(change_bet_hook: ->(bet){ bet.to_f / 2 })
  )
)
```

