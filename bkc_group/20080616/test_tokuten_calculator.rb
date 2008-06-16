require 'test/unit'
require 'tokuten'

class TokutenCalculatorTest < Test::Unit::TestCase
  def test_calc_tokuten
    input = <<END
3
1000
342
0
5
2
2
9
11
932
5
300
1000
0
200
400
8
353
242
402
274
283
132
402
523
0

END

    expected = <<END
342
7
300
326
END

    calculator = Tokuten::Calculator.new
    output = calculator.calc(input)

    assert_equal(expected, output)
  end
end
