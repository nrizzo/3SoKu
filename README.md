# 3coSoKu
This project started as an assignment for the course Automated Reasoning at the Master in Computer Science at University of Udine.

## Results
The main results I found, described [here](https://github.com/nrizzo/3SoKu/blob/master/documentation.pdf), are that:
- 3coSoKu, that is generalized IcoSoKu where you keep the rules of the game but you can play on any polyhedron with triangular faces (hence the name), is NP-complete;
- every instance of IcoSoKu can indeed be solved (I checked them all!);
- in solving instances of IcoSoKu, a randomized exploration of the search tree with a restart after a constant amount of time is a great strategy, because it seems that there always are a lot (tens of millions!) of different solutions (does this mean that it is a good strategy in practice? I have to try that...).

## Solvers
I have developed two main [solvers](https://github.com/nrizzo/3SoKu/tree/master/solvers) for 3coSoKu, also described [here](https://github.com/nrizzo/3SoKu/blob/master/documentation.pdf), one in MiniZinc and one in ASP.
