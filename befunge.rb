#!/usr/bin/env ruby

class BefungeProgram

  HORIZ_SIZE = 80
  MAX_X = HORIZ_SIZE - 1
  VERT_SIZE = 25
  MAX_Y = VERT_SIZE - 1

  def initialize(program_lines)
    raise "Error: Program exceeds 25 lines" if program_lines.length > VERT_SIZE

    @program = []
    (0..MAX_Y).each do |y|
      line = []
      (0..MAX_X).each do |x|
        line << ' '
      end
      @program << line
    end

    program_lines.each_index do |p|
      line = program_lines[p].chomp.split(//)
      raise "Error: Line #{p} exceeds 80 characters" if line.length > HORIZ_SIZE
      line.each_index do |c|
        @program[p][c] = line[c]
      end
    end
  end

  def print_program
    print '#' * (HORIZ_SIZE + 2), "\n"
    @program.each do |line|
      print '#'
      line.each do |char|
        print char
      end
      print "#\n"
    end
    print '#' * (HORIZ_SIZE + 2), "\n"
  end

  def execute(peek = false)
    pc = [0,0]
    direction = :right
    while true
      puts "pc: #{pc.inspect}" if peek
      puts "operation: #{@program[pc[0]][pc[1]]}" if peek
      result = run_op(@program[pc[0]][pc[1]])
      puts "result: #{result.nil? ? 'nil' : result}" if peek
      if result.nil?
        #nothing to do
      elsif :exit == result
        break
      else
        direction = result 
      end
      pc = move_pc(pc, direction)
    end
  end

  def run_op(operation)
    result = nil
    case operation
    when '<': result = :left
    when '>': result = :right
    when '^': result = :up
    when 'v': result = :down
    end
    return result
  end

  def move_pc(pc, direction)
    case direction
    when :right
      pc[1] += 1
      pc[1] = 0 if pc[1] > MAX_X
    when :left
      pc[1] -= 1
      pc[1] = MAX_X if pc[1] < 0
    when :down
      pc[0] += 1
      pc[0] = 0 if pc[0] > MAX_Y
    when :up
      pc[0] -= 1
      pc[0] = MAX_Y if pc[0] < 0
    end
    return pc
  end

end

if $0 == __FILE__
  lines = File.readlines(ARGV[0])
  bfp = BefungeProgram.new(lines)
  bfp.print_program
  bfp.execute(true)
end
