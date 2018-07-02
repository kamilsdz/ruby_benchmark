require "ruby_benchmark/version"
require 'ruby-prof'

module RubyBenchmark
  extend self

  def run(options = { gc: :enable })
    if options[:gc] == :disable
      GC.disable
    elsif options[:gc] == :enable
      GC.start
    end

    memory_before = `ps -o rss= -p #{ Process.pid }`.to_i/1024
    gc_stat_before = GC.stat
    time = Benchmark.realtime do
      yield
    end
    gc_stat_after = GC.stat
    GC.start if options[:gc] == :enable
    memory_after = `ps -o rss= #{ Process.pid }`.to_i/1024

    puts({
             RUBY_VERSION => {
                 gc: options[:gc],
                 time: time.round(2),
                 gc_count: gc_stat_after[:count].to_i - gc_stat_before[:count].to_i,
                 memory: "%d MB " % (memory_after - memory_before)
             }
         }.to_json)
  end

  def generate_flat(min = 1)
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::FlatPrinter.new(result)
    binding.pry
    printer.print(File.open('flat_report.txt', 'w+'), min_percent: min)
  end

  def generate_graph(min = 1)
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::GraphPrinter.new(result)
    printer.print(File.open('graph_report.txt', 'w+'), min_percent: min)
  end

  def generate_call_stack
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::CallStackPrinter.new(result)
    printer.print(File.open('call_stack_report.html', 'w+'))
  end

  def generate_call_tree
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::CallTreePrinter.new(result)
    printer.print(File.open('callgrind_report.out.app', 'w+'))
  end
end
