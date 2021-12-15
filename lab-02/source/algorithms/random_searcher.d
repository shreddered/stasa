module algorithms.random_searcher;

import algorithms.searcher;

import std.algorithm : each, map, min, reduce;
import std.array : array;
import std.math : log;
import std.random : uniform;
import std.range : generate, iota, takeExactly;
import std.stdio : write, writef, writefln, writeln;

class RandomSearcher(alias func) : ISearcher {
    private double _a, _b;

    public override void setInterval(in double a, in double b) {
        _a = a;
        _b = b;
    }

    private void print(in double[] p, in double[] q, in double[][] mins) {
        // table header
        writeln("Точки минимума функции в зависимости от p и q");
        writeln("+-------+---------+---------+---------+---------",
                "+---------+---------+---------+---------+---------",
                "+---------+");
        write("|  q\\P  ");
        p.each!((a) => writef("|  %-2.2f   ", a));
        writeln('|');
        writeln("+-------+---------+---------+---------+---------",
                "+---------+---------+---------+---------+---------",
                "+---------+");

        foreach(i, seq; mins) {
            writef("| %-1.3f ", q[i]);
            foreach(j, elem; seq) {
                writef("|%9,2.4f", elem);
            }
            writeln('|');
        }
        // table bottom
        writeln("+-------+---------+---------+---------+---------",
                "+---------+---------+---------+---------+---------",
                "+---------+");
    }

    private void printN(in double[] p, in double[] q, in ulong[][] n) {
        writeln("Зависимость N от p и q");
        // table header
        writeln("+-------+---------+---------+---------+---------",
                "+---------+---------+---------+---------+---------",
                "+---------+");
        write("|  q\\P  ");
        p.each!((a) => writef("|  %-2.2f   ", a));
        writeln('|');
        writeln("+-------+---------+---------+---------+---------",
                "+---------+---------+---------+---------+---------",
                "+---------+");

        foreach(i, seq; n) {
            writef("| %-1.3f ", q[i]);
            foreach(j, elem; seq) {
                writef("|%9d", elem);
            }
            writeln('|');
        }

        // table bottom
        writeln("+-------+---------+---------+---------+---------",
                "+---------+---------+---------+---------+---------",
                "+---------+");
    }
    public override void search(const double eps) {
        enum double[] p = iota(0.9, 1.0, 0.01).array;
        enum double[] q = iota(0.005, 0.105, 0.005).array;

        // computes 2D range (matrix) n = log(1 - p)/log(1 - q) at compile time
        // first mapping maps every q to another mapping
        // which maps every p to log(1 - p)/log(1 - q)
        enum ulong[][] n = q.map!((q_) => p
                .map!((p_) => cast(ulong) (log(1 - p_)/log(1 - q_)))
                .array)
                .array;
        printN(p, q, n);
        writeln;
        // helper function for generating n random numbers
        alias generateNRandomNumbers = (ulong _n) => generate(() => uniform!"[]"(_a, _b)).takeExactly(_n);

        // 2D range of minimums
        double[][] mins = n.map!((str) => str
                // generate n random numbers in [a, b] for each n
                .map!generateNRandomNumbers
                // for each sequence select function's minimum
                .map!((seq) => seq.map!func // function values
                    .reduce!min)
                .array)
                .array;
        print(p, q, mins);
    }
}
