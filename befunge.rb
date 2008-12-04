class Befunge

  attr_accessor :direction, :no_skip, :stringmode
  attr_reader :height, :width, :output, :pc_x, :pc_y, :program, :stack

  # commands are done this way to make it easy to push a Befunge instance
  # into a Rails session. The procs don't like to be serialized if they 
  # are in an instance or class variable, which would prevent needing to
  # pass the instance in as a parameter... but this ain't so bad anyway

  COMMANDS = {
    ' ' => lambda{ }, # no op
    '+' => lambda{|x| a,b = x.pop2i; x.push(b + a) }, # add
    '-' => lambda{|x| a,b = x.pop2i; x.push(b - a) }, # subtract
    '*' => lambda{|x| a,b = x.pop2i; x.push(b * a) }, # multiply
    '/' => lambda{|x| a,b = x.pop2i; x.push(b / a) }, # divide
    '%' => lambda{|x| a,b = x.pop2i; x.push(b % a) }, # modulo
    '!' => lambda{|x| x.push(x.popi == 0 ? 1 : 0) }, # not
    '`' => lambda{|x| a,b = x.pop2i; x.push(b > a ? 1 : 0) }, # greater
    '>' => lambda{|x| x.direction = :right }, # right
    '<' => lambda{|x| x.direction = :left }, # left
    '^' => lambda{|x| x.direction = :up }, # up
    'v' => lambda{|x| x.direction = :down }, # down
    '?' => lambda{|x| x.direction = [:right, :left, :up, :down][rand(4)] }, # random
    '_' => lambda{|x| x.direction = (x.popi == 0 ? :right : :left) }, # horiz if
    '|' => lambda{|x| x.direction = (x.popi == 0 ? :down : :up) }, # vert if
    '"' => lambda{|x| x.stringmode = (not x.stringmode) }, # stringmode
    ':' => lambda{|x| a = x.pop; x.push(a); x.push(a) }, # dup
    "\\" => lambda{|x| a,b = x.pop2; x.push(a); x.push(b) }, # swap
    '$' => lambda{|x| x.pop }, # pop -> no op
    '.' => lambda{|x| x.print_i(x.pop) }, # pop -> print as integer
    ',' => lambda{|x| x.print_a(x.pop) }, # pop -> print as ascii
    '#' => lambda{|x| x.move_pc }, # bridge (skip)
    'g' => lambda{|x| a,b = x.pop2; x.push(x.get_cell(b,a)) }, # get
    'p' => lambda{|x| a,b = x.pop2; v = x.pop; x.set_cell(v,b,a) }, # put
    '&' => lambda{|x| x.input_i }, # input integer
    '~' => lambda{|x| x.input_a }, # input ascii
    '@' => lambda{|x| x.direction = :end } # end
  }

  def initialize(program = nil, height = 25, width = 80)
    @height = height
    @width = width
    #programs are stored as row, column (y, x)
    @program =  Array.new(@height){|i| Array.new(@width, ' ') }
    parse(program)

    @output = ''
    @stack = []
    @pc_x = 0
    @pc_y = 0
    @direction = :right
    @stringmode = false

    @print = nil
    @no_skip = false
  end

  def at_end?
    @direction == :end
  end

  def define_print(&block)
    @print = block
  end

  def get_cell(x, y)
    @program[y.to_i][x.to_i]
  end

  def input_a
    @stack << rand(255).chr
  end

  def input_i
    @stack << rand(255)
  end

  def move_pc
    case @direction
    when :right
      @pc_x = (@pc_x + 1 ) % @width
    when :left
      @pc_x = (@pc_x - 1 ) % @width
    when :up
      @pc_y = (@pc_y - 1 ) % @height
    when :down
      @pc_y = (@pc_y + 1 ) % @height
    when :end
      # give it up, bro
    else
      raise "Invalid direction: #{@direction}"
    end
  end

  def parse(program)
    raise "Error: Program exceeds #{@height} lines (it has #{program.length})" if program.length >= @height
    row_number = 0
    program.each do |line|
      column_number = 0
      chars = line.chomp.split(//)
      raise "Error: Line #{row_number + 1} exceeds #{@width} columns" if chars.length >= @width
      chars.each do |char|
        @program[row_number][column_number] = char
        column_number += 1
      end
      row_number += 1
    end
  end

  def pop
    x = @stack.pop
    x.nil? ? 0 : x
  end

  def popi
    x = pop
    i = (x == x.to_i) ? x : x[0]
  end

  def pop2
    [pop, pop]
  end

  def pop2i
    [popi, popi]
  end

  def push(a)
    @stack << a
  end

  def print(s)
    if @print.nil?
      @output << s
    else
      @print.call(s)
    end
  end

  def print_a(c)
    if c.respond_to?(:chr)
      print(c.chr)
    else
      print(c)
    end
  end

  def print_i(c)
    if c.respond_to?(:chr)
      print(c.to_s)
    else
      print(c[0].to_s)
    end
  end

  def set_cell(value, x, y)
    if value.respond_to?(:chr)
      @program[y.to_i][x.to_i] = value.chr
    else
      @program[y.to_i][x.to_i] = value
    end
  end

  def skip_spaces
    next_op = get_cell(@pc_x, @pc_y)
    while next_op == " "
      move_pc
      next_op = get_cell(@pc_x, @pc_y)
    end
  end

  def step
    op = @program[@pc_y][@pc_x]
    if @stringmode
      if '"' == op
        @stringmode = false
      else
        @stack << op
      end
    else
      if COMMANDS.has_key?(op)
        COMMANDS[op].call(self)
      elsif op.match(/\d/)
        @stack << op.to_i
      else
        # we could raise a syntax error?
      end
    end
    move_pc
    skip_spaces unless @stringmode || @no_skip
    return op
  end
  
end


class BefungeConsoleRunner
  
  def initialize(program)
    @befunge = Befunge.new(program)
    @befunge.define_print{|c| print c }
  end
  
  def run
    @befunge.step until @befunge.at_end?
  end
  
end


class BefungeConsoleDebugger
  
  def initialize(program, debug_break)
    @befunge = Befunge.new(program)
    @debug_break = debug_break.nil? ? 16 : debug_break.to_i
    @debug_count = 0
    print_torus
  end

  def print_output
    puts "Output: #{@befunge.output.inspect}"
  end

  def print_stack
    puts "Stack: #{@befunge.stack.inspect}"
  end

  def print_torus
    puts "\n", '#' * (@befunge.width + 2)
    @befunge.program.each{|row| print '#', row.join, '#', "\n" }
    puts '#' * (@befunge.width + 2), "\n" 
  end

  def print_registers
    puts ["Program counter: (#{@befunge.pc_x}, #{@befunge.pc_y})",
          "Direction: #{@befunge.direction}",
          "Stringmode: #{@befunge.stringmode}"].join("; ")
  end

  def run
    until @befunge.at_end?
      @debug_count += 1
      puts @befunge.step.inspect
      
      if @debug_count >= @debug_break
        while true
          print "[o]utput, [s]tack, [t]orus, [r]egisters, [q]uit, []continue (+ ENTER):"
          
          case $stdin.gets
          when /o/i: print_output
          when /s/i: print_stack
          when /t/i: print_torus
          when /r/i: print_registers
          when /q/i: exit
          when /^\n$/: break
          else # invalid input, ask again
          end
        end
        @debug_count = 0
      end
    end
    puts @befunge.output
  end
  
end


if $0 == __FILE__
  mode = nil
  case ARGV[0]
  when /run/i : mode = :run
  when /debug/i : mode = :debug
  end
  
  # Valid mode and filename are required
  if mode.nil? || ARGV.length < 2
    puts "Usage: ruby befunge.rb <run|debug> <befunge.bf> <iterations>"
    puts
    puts "  run: run the program normally"
    puts "debug: run the program in debug mode stopping every <iterations>"
    puts "       to confirm continuation"
    exit
  end
  
  # Assume the user called with a valid filename
  if mode == :run
    bf = BefungeConsoleRunner.new(File.readlines(ARGV[1]))
  else
    bf = BefungeConsoleDebugger.new(File.readlines(ARGV[1]), ARGV[2])
  end

  bf.run
  puts
end
