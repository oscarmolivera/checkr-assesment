#!/usr/bin/env ruby

=begin

A rover's position and location is represented by a combination of x and y
coordinates and a letter representing one of the four cardinal compass points.
The plateau is divided up into a grid to simplify navigation. An example
position might be 0, 0, N, which means the rover is in the bottom left corner
and facing North.

In order to control a rover, NASA sends a simple string of letters. The possible
letters are 'L', 'R' and 'M'. 'L' and 'R' makes the rover spin 90 degrees left
or right respectively, without moving from its current spot. 'M' means move
forward one grid point, and maintain the same heading.

Assume that the square directly North from (x, y) is (x, y+1).

=end
class Rover
  def initialize(initial_position, plateau)
    @grid_size = plateau.map(&:to_i)
    conversion = initial_position.split(' ')
    @coordinates = conversion[0..1].map(&:to_i)
    @rover_facing = conversion.last.capitalize
  end

  def commands(list)
    @commands = list.chars
  end

  def explore
    @commands.each do |command|
      break unless out_of_bounds?
      command == 'M' ? move : rotate(command)
    end
    new_coordenates = @coordinates.map(&:to_s).join(' ')
    final_facing = @rover_facing.to_s
    out_of_bounds? ? 'new position:' + new_coordenates + ' ' + final_facing : 'Signal lost: Rover out of bounds'
  end

  private

  def rotate(command)
    turn = directions[@rover_facing]
    @rover_facing = command == 'L' ? turn.first : turn.last
  end

  def move
    case @rover_facing
    when 'N'
      @coordinates[1] += 1
    when 'E'
      @coordinates[0] += 1
    when 'S'
      @coordinates[1] -= 1
    when 'W'
      @coordinates[0] -= 1
    end
  end

  def out_of_bounds?
    (0..@grid_size[0]).cover?(@coordinates[0]) &&
      (0..@grid_size[1]).cover?(@coordinates[1])
  end

  def directions
    { 'N' => %w[W E],
      'E' => %w[N S],
      'S' => %w[E W],
      'W' => %w[S N] }
  end
end

@num = 0
if File.exist?(ARGV[0])
  unless (ARGV[0]).nil?
    puts '===================== Checkr Assessment ========================='
    puts '................. Explore Mars with Rovers.......................'
    puts ''
    File.foreach(ARGV[0]) do |line|
      @plateau = line[/(\d+\s\d+)\n/, 1].split(' ') unless line[/(\d+\s\d+)\n/, 1].nil?
      case line
      when /(\d+\s\d+\s[neswNESW])\n/
        @position_line = (line[/(\d+\s\d+\s[neswNESW])/])
      when /[MRL]+/
        rover = Rover.new(@position_line, @plateau)
        rover.commands(line[/[MRL]+/])
        @num += 1
        puts "Rover#{@num} Initial position: #{@position_line} | #{rover.explore}"
        puts '_____________________________________________________'
      else
        next
      end
    end
  end
  puts @num < 1 ? 'No commands were went to Mars rovers' : " Total Rovers Moved: #{@num}"
else
  puts "CHECK FILE: No File were found"
end

