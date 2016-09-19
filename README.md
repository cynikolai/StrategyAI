# StrategyAI
A simple exercise in using AI for strategy.

This program implements two strategy modes for playing tic-tac-toe:
- A slight modification of a nash-equilibrium algorithm that never loses
- A neural network trained to play the game against itself.

The algorithms can actually easily be extended to any other game with discrete states, but these will quickly become too complex for a one-layer neural network to learn, and the state space would be far too large to find a dominant strategy. 

Built for personal practice over the course of ~10 hours.
