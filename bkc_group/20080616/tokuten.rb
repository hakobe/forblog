module Tokuten
  class Calculator
    def calc(input)
      datasets = Tokuten::Parser.parse(input)
      results  = self.do_calc(datasets)

      output = results.join("\n") + "\n"
      return output
    end

    def do_calc(datasets)
      results = []
      datasets.each do |dataset|
        results << (dataset.inject {|n,m| n+=m} - dataset.min - dataset.max) / (dataset.size - 2)
      end
      return results
    end
  end

  class Parser
    def self.parse(input)
      lines = input.split(/\n/)

      datasets = []
      loop do
        line = lines.shift
        num = line.to_i
        break if num == 0

        dataset = []
        num.times do 
          dataset << lines.shift.to_i
        end

        datasets << dataset
      end
      return datasets
    end
  end
end
