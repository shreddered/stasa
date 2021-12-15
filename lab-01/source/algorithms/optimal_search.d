module algorithms.optimal_search;

import algorithms.searcher;

import std.algorithm : map, min, minIndex;
import std.array : array;
import std.math : exp;
import std.range : iota;
import std.stdio : writeln, writefln;

class OptimalPassiveSearcher(alias func) : ISearcher {
    private double _a, _b;
    private double delta(in ulong n) @safe pure nothrow {
        return (_b - _a) / (n + 1);
    }
    public override void setInterval(in double a, in double b) {
        _a = a;
        _b = b;
    }
    public override void search(const double eps = 0.1) {
        ulong n;
        writefln("|%-20s|%-20s|", "Количество точек (N)", "Точка минимума");
        writeln("|--------------------|--------------------|");
        double ans;
        for (n = 2; delta(n) * 2 >= eps; ++n) {
            double[] x = iota(1, n + 1)
                .map!(k => delta(n) * k + _a)
                .array;
            ulong index = x.map!func
                .minIndex;
            ans = x[index];
            writefln("|%-20d|%- 3.7f±%-3.7f|", n, ans, delta(n));
        }
        writeln("|--------------------|--------------------|");
        writefln!"x = %3.7f±%3.7f"(ans, delta(n - 1));
    }
}
