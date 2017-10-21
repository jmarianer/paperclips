module Fibonacci exposing (Fib, start, get, advance)

type alias Fib = (Int, Int)

start : Fib
start = (1, 1)

get : Fib -> Int
get = Tuple.first

advance : Fib -> Fib
advance (a, b) = (b, a+b)
