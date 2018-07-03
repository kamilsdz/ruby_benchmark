require 'ruby_benchmark/version'
require 'fileutils'
require 'ruby-prof'
require 'stackprof'
require 'benchmark'

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
    printer.print(File.open('tmp/profile/flat_report.txt', 'w+'), min_percent: min)
  end

  def generate_graph(min = 1)
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::GraphPrinter.new(result)
    printer.print(File.open('tmp/profile/graph_report.txt', 'w+'), min_percent: min)
  end

  def generate_call_stack
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::CallStackPrinter.new(result)
    printer.print(File.open('tmp/profile/call_stack_report.html', 'w+'))
  end

  def generate_call_tree
    GC.disable
    result = ::RubyProf.profile do
      yield
    end
    printer = ::RubyProf::CallTreePrinter.new(result)
    printer.print(path: '.', profile: 'tmp/profile/profile')
    system('qcachegrind')
  end

  def generate_stackprof(options = 'flamegraph')
    FileUtils::mkdir_p 'tmp/profile'
    GC.disable
    ::StackProf.run(
      mode: :object,
      out: 'tmp/profile/stackprof-object.dump',
      raw: true,
      interval: 1) do
        yield
      end

    if options == 'text'
      puts `stackprof tmp/profile/stackprof-object.dump --text`
    elsif options == 'flamegraph'
      `stackprof --flamegraph tmp/profile/stackprof-object.dump > tmp/profile/flamegraph`
      link = `stackprof --flamegraph-viewer=tmp/profile/flamegraph`
      puts link
      link.slice!('open ')

      if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
        system "start #{link}"
      elsif RbConfig::CONFIG['host_os'] =~ /darwin/
        system "open #{link}"
      elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
        system "xdg-open #{link}"
      end
    end
  end
end
