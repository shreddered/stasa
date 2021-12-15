import algorithms;

import std.math : exp;
import std.stdio : writeln, writefln;

alias fun = (x) => (1 - x) * (1 - x) + exp(x);

int main() {
    writeln("Таблица 1 -- поиск минимума методом оптимального пассивного поиска");
    ISearcher searcher = new OptimalPassiveSearcher!fun;
    searcher.setInterval(-5, 2);
    searcher.search(0.1);

    writeln;
    writeln("Таблица 2 -- поиск минимума методом Фибоначчи");

    searcher = new FibonacciSearcher!fun;
    searcher.setInterval(-5, 2);
    searcher.search(0.1);
    return 0;
}
