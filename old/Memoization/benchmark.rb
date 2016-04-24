require 'benchmark'

module Fib
  module_function

  def fib(n)
    if n <= 1
      n
    else
      fib(n - 1) + fib(n - 2)
    end
  end

  def memoized_fib(n)
    @cache ||= {}
    @cache[n] ||= if n <= 1
      n
    else
      memoized_fib(n - 1) + memoized_fib(n - 2)
    end
  end
end

puts "Un memoized fib"
puts Benchmark.measure { Fib.fib(40) }

puts "memoized fib"
puts Benchmark.measure { Fib.memoized_fib(40) }
