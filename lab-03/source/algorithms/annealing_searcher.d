module algorithms.annealing_searcher;

import algorithms.searcher;

import std.math : exp;
import std.random : uniform;
import std.stdio : writefln, writeln;

class AnnealingSearcher(alias func) : ISearcher {
    private double _a, _b;

    public override void setInterval(in double a, in double b) {
        _a = a;
        _b = b;
    }

    public override void search() {
        // function for evaluating probability of transition
        alias probability = (delta, t) => exp(-delta/t);

        // table header
        writeln("+-----+----------+-------+-------+");
        writefln("|%5c|%10c|%7c|%7s|", 'N', 'T', 'x', "f(x)");
        writeln("+-----+----------+-------+-------+");

        // initial values
        const double t_min = 0.1;
        double x_min = uniform(_a, _b);
        size_t counter = 0;

        for (double t_max = 1000.0; t_max > t_min; t_max *= 0.95) {
            double x_i = uniform(_a, _b);
            double diff = func(x_i) - func(x_min);
            if (diff <= 0.0) {
                x_min = x_i;
            }
            else {
                auto temp = uniform!"[]"(0.0, 1.0);
                if (temp < probability(diff, t_max)) {
                    x_min = x_i;
                }
            }
            writefln("|%5d|%10,4.5f|%7,3.3f|%7,3.3f|", counter++, t_max, x_min, func(x_min));
        }

        // table footer
        writeln("+-----+----------+-------+-------+");
    }
}
