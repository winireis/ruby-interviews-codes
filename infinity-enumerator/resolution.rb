# The aim of this class is to take a number of ordered enumerators and then
# emit their values in ascending order.
#
# Some assumptions:
#   * The enumerators passed in emit their values in ascending order.
#   * The enumerators emit values which are Comparable[1] with each other.
#   * The enumerators can be finite *or* infinite.
#
# This requires Ruby 1.9. The Enumerator[2] documentation might be useful.
#
# [1] http://www.ruby-doc.org/core-1.9.3/Comparable.html
# [2] http://www.ruby-doc.org/core-1.9.3/Enumerator.html
#
# This is a stub implementation that causes failures in in the test suite, but
# no errors.
#
# You can run the test suite with: `ruby resolution.rb`.

class CombinedOrderedEnumerator < Enumerator

  class UnorderedEnumerator < RuntimeError
    attr_reader :enumerator
    def initialize(enumerator)
      @enumerator = enumerator
    end
  end

  def initialize(*enumerators)
    super() do |yielder|
      values = []
      enumerators.each do |enumerator|
        fragment = lazy(enumerator) { |value| ascending? enumerator }.take(@amount)
        values.push(fragment)
      end
      values.flatten.sort.each { |value| yielder.yield value }
    end
  end

  #To iterate lazily over the original enumerator
  def lazy(enumerator, &block)
    Enumerator.new do |yielder|
      enumerator.each do |value|
        yielder.yield value if block.call enumerator
      end
    end
  end

  #Validate the ascending order of the enumerator
  #Due to lazzynes nature of the enumerators, you only discover that it is
  #unordered when you reach the element out of the order
  def ascending?(enumerator)
    ascending = enumerator.each_cons(2).take(@amount).all? { |values| values[0] <= values[1] }
    ascending || raise(CombinedOrderedEnumerator::UnorderedEnumerator, enumerator)
  end

  def take(n)
    @amount = n
    super
  end
end


if $0 == __FILE__
  require 'minitest/autorun'
  require 'minitest/pride'

  class CombinedOrderedEnumeratorTest < MiniTest::Unit::TestCase
    def test_enumerating_nothing
      enumerator = CombinedOrderedEnumerator.new()
      assert_equal [], enumerator.take(10)
    end

    def test_enumerating_with_a_single_enumerator
      enumerator = CombinedOrderedEnumerator.new((1..5).to_enum)
      assert_equal [1, 2, 3, 4, 5], enumerator.take(10)
    end

    def test_enumerating_with_two_empty_arrays
      enumerator = CombinedOrderedEnumerator.new([].to_enum, [].to_enum)
      assert_equal [], enumerator.take(20)
    end

    def test_enumerating_with_one_empty_array_and_finite_sequence
      enumerator = CombinedOrderedEnumerator.new([].to_enum, (1..10).to_enum)
      assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], enumerator.take(20)
    end

    def test_enumerating_with_one_empty_array_and_finite_sequence_with_switched_args
      enumerator = CombinedOrderedEnumerator.new((1..10).to_enum, [].to_enum)
      assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], enumerator.take(20)
    end

    def test_enumerating_an_infinite_sequence_and_finite_one
      enumerator = CombinedOrderedEnumerator.new(fibonacci, (1..10).to_enum)
      assert_equal [0, 1, 1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 7, 8, 8, 9, 10, 13, 21, 34], enumerator.take(20)
    end

    def test_enumerating_two_infinite_sequences
      enumerator = CombinedOrderedEnumerator.new(fibonacci, sum_of_natural_numbers)
      assert_equal [0, 1, 1, 1, 2, 3, 3, 5, 6, 8, 10, 13, 15, 21, 21, 28, 34, 36, 45, 55], enumerator.take(20)
    end

    def test_enumerating_three_finite_sequences
      enumerator = CombinedOrderedEnumerator.new((1..5).to_enum, (1..3).to_enum, (4..10).to_enum)
      assert_equal [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8, 9, 10], enumerator.take(20)
    end

    def test_enumerating_three_infinite_sequences
      enumerator = CombinedOrderedEnumerator.new(fibonacci, fibonacci, fibonacci)
      assert_equal [0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2], enumerator.take(12)
    end

    def test_raises_unordered_enumerator_exception_if_enumerator_isnt_in_ascending_order
      enumerator = CombinedOrderedEnumerator.new(10.downto(1))

      assert_raises(CombinedOrderedEnumerator::UnorderedEnumerator) do
        enumerator.take(20)
      end
    end

    def test_raising_unordered_enumerator_should_reference_enumerator
      #decending_enumerator = 10.downto(1)
      decending_enumerator = [10,10,9,10,10].to_enum
      enumerator = CombinedOrderedEnumerator.new(decending_enumerator)

      begin
        enumerator.take(2)
        assert true
      rescue CombinedOrderedEnumerator::UnorderedEnumerator => exception
        assert_equal decending_enumerator, exception.enumerator
      end
    end

    private

    class FibonacciEnumerator < Enumerator
      def initialize
        super() do |yielder|
          a, b = 0, 1

          loop do
            yielder.yield a
            a, b = b, (a + b)
          end
        end
      end
    end

    def fibonacci
      FibonacciEnumerator.new
    end

    class SumOfNaturalNumbersEnumerator < Enumerator
      def initialize
        super() do |yielder|
          n = 1

          loop do
            yielder.yield sum = (n * (n + 1)) / 2
            n += 1
          end
        end
      end
    end

    def sum_of_natural_numbers
      SumOfNaturalNumbersEnumerator.new
    end
  end
end
