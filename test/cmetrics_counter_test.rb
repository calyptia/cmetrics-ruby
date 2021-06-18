# frozen_string_literal: true

require "test_helper"

class CMetricsCounterTest < Test::Unit::TestCase
  sub_test_case "counter" do
    setup do
      @counter = CMetrics::Counter.new
      @counter.create("kubernetes", "network", "load", "Network load", ["hostname", "app"])
    end

    def test_counter
      assert_equal 0.0, @counter.val
      @counter.inc
      assert_equal 1.0, @counter.val

      @counter.add 2.0
      assert_equal 3.0, @counter.val
      puts @counter.to_prometheus
    end

    def test_labels
      assert_true @counter.inc(["localhost", "cmetrics"])
      assert_equal 1.0, @counter.val(["localhost", "cmetrics"])

      assert_true @counter.add(10.55, ["localhost", "test"])
      assert_equal 10.55, @counter.val(["localhost", "test"])

      assert_true @counter.set(12.15, ["localhost", "test"])
      assert_false @counter.set(1, ["localhost", "test"])
      puts @counter.to_prometheus
    end
  end
end