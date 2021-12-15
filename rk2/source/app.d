module main;

import std.algorithm : each, maxElement, sort, reduce;
import std.array : array;
import std.math : exp, pow;
import std.random : uniform;
import std.stdio : writeln, writefln;
import std.typecons : Tuple;

alias fn = (x, y) => exp(-pow(x, 2) - pow(y, 2));

immutable ulong N = 6u;

// helper alias for convenient point usage
alias Point = Tuple!(double, "x", double, "y", double, "fit");

void generatePoint(alias func)(ref Point p) {
    p.x = uniform!"()"(-2.0, 2.0);
    p.y = uniform!"()"(-2.0, 2.0);
    p.fit = func(p.x, p.y);
}

Point crossover(alias func)(Point p1, Point p2) {
    Point res;
    res.x = p1.x;
    res.y = p2.y;
    res.fit = func(res.x, res.y);
    return res;
}

void mutate(alias func)(ref Point p) {
    with(p) {
        if (uniform!"[]"(0.0, 1.0) <= 0.25)
            x += uniform!"()"(-1.0, 1.0);
        if (uniform!"[]"(0.0, 1.0) <= 0.25)
            y += uniform!"()"(-1.0, 1.0);
        if (x > 2)
            x = 2;
        if (x < -2)
            x = -2;
        if (y > 2)
            y = 2;
        if (y < -2)
            y = -2;
        fit = func(x, y);
    }
}

void print(Point[] arr) {
    // counter
    static size_t iter;

    auto fit = arr[].fit;

    writefln!"N = %d\nX = [%(%2.5f, %)]\nY = [%(%2.5f, %)]\nFit = [%(%2.5f, %)]"(iter, arr[].x, arr[].y, fit); 
    writefln!"Max = %2.5f, Average = %2.5f"(fit.maxElement, fit.reduce!"a + b" / N);
    writeln;
    ++iter;
}

@property double[] x(Point[] p) {
    double[] result = new double[] (p.length);
    foreach(i, elem; p)
        result[i] = elem.x;
    return result;
}

@property double[] y(Point[] p) {
    double[] result = new double[] (p.length);
    foreach(i, elem; p)
        result[i] = elem.y;
    return result;
}

@property double[] fit(Point[] p) {
    double[] result = new double[] (p.length);
    foreach(i, elem; p)
        result[i] = elem.fit;
    return result;
}

int main() {
    writeln("f(x, y) = exp(-x^2 - y^2)");

    Point[] arr = new Point[] (N);

    // zero population generation
    arr.each!(generatePoint!fn);

    // helper function for selecting two random points
    alias select2 = (arr) {
        ulong i1, i2;
        while (i1 != i2) {
            i1 = uniform(0, arr.length);
            i2 = uniform(0, arr.length);
        }
        return [arr[i1], arr[i2]];
    };

    foreach(_; 0..11) {
        print(arr);

        auto pair = select2(arr);

        // crossover
        arr ~= crossover!fn(pair[0], pair[1]);

        // mutation
        arr.each!(mutate!fn);

        // selection
        sort!"a.fit > b.fit"(arr);
        // NOTE: there's no leak because of GC in D
        arr = arr[0..N];
    }
    return 0;
}
