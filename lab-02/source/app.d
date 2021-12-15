import algorithms;

import std.math : exp, sin;
import std.stdio : writeln;

alias fun1 = (x) => (1 - x) * (1 - x) + exp(x);

alias fun2 = (x) => fun1(x) * sin(5 * x);

int main() {
    writeln("f(x) = (1 - x)^2 + exp(x)");
    ISearcher searcher = new RandomSearcher!fun1;
    searcher.setInterval(-5, 2);
    searcher.search();

    writeln('\n', "f1(x) = f(x) * sin(5 * x)");
    searcher = new RandomSearcher!fun2;
    searcher.setInterval(-5, 2);
    searcher.search();
    return 0;
}
