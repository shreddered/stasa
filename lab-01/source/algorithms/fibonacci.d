module algorithms.fibonacci;

import algorithms.searcher;

import std.array : array;
import std.range : recurrence, take;
import std.stdio : writeln, writefln;

class FibonacciSearcher(alias func) : ISearcher {
    private double _a, _b;
    private pragma(inline) double interval() const @safe pure nothrow {
        return _b - _a;
    }
    public override void setInterval(in double a, in double b) {
        _a = a;
        _b = b;
    }
    public override void search(const double eps = 0.1) {
        // first N fibonacci numbers will be evaluated at compile time
        enum ulong N = 30;
        enum fib = recurrence!"a[n - 1] + a[n - 2]"(1, 1)
            .take(N + 3)
            .array;
        // table header
        writefln!"N = %d"(N);
        writefln("|%-20s|%-20s|", "Количество точек (N)", "Точка минимума");
        writeln("|--------------------|--------------------|");

        // preparations
        double x1 = _a + interval() * fib[N] / fib[N + 2],
               x2 = _a + _b - x1;
        double y1 = func(x1), y2 = func(x2);
        for (ulong k = 0; k != N && interval() >= eps; ++k) {
            if (y1 > y2) {
                _a = x1;
                x1 = x2;
                x2 = _a + _b - x1;
                y1 = y2;
                y2 = func(x2);
            }
            else {
                _b = x2;
                x2 = x1;
                x1 = _a + _b - x2;
                y2 = y1;
                y1 = func(x1);
            }
            writefln!"|%-20d|%- 3.7f±%-3.7f|"(k + 1, (_a + _b) / 2, interval() / 2);
        }
        writeln("|--------------------|--------------------|");
        writefln!"x = %3.7f±%3.7f"((_a + _b) / 2, interval() / 2);
    }
}
