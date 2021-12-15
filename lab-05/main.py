#!/usr/bin/env python3

from approximator import Approximator

if __name__ == "__main__":
    approx = Approximator(n = 20, interval = (-2, 1), params = (0.5, 0))
    res = approx.search(amp = 1)
    print("c = {}, d = {}".format(res[0], res[1]))
