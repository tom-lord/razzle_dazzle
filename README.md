## Razzle Dazzle

A flexible simulation for the [razzle dazzle game](http://www.goodmagic.com/websales/midway/razzle.htm).

[This youtube video](https://www.youtube.com/watch?v=KaIZl0H2yNE) does a good job
of explaining the game rules, and how scam artists manipulate players.

This code is designed to simulate a real game - so you can play under whatever "rules"
you like, without spending a penny!

## Usage

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

##### Non-Configurable (yet)

* There are **8** balls rolled each turn.
* Your initial bet-per-play is **1**.
* Your "winning score" is **10**.

##### Configurable

* The game board contains 120 scores, as taken from
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

* The special score of **29** (see the above board game image) is defined to
mean "increase your bet by 1".
(You can re-define this score, or any other score, to change the price-per-play in any way.)

