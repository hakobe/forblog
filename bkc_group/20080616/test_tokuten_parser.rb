require 'test/unit'
require 'tokuten'

class TokutenParserTest < Test::Unit::TestCase
  def test_parse
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
0

END
    datasets = Tokuten::Parser.parse(input)

    assert_equal([1000, 342, 0], datasets.shift)
    assert_equal([2, 2, 9, 11, 932], datasets.shift)
    assert_equal([0], datasets.shift)
    assert_nil(datasets.shift)
  end
end
