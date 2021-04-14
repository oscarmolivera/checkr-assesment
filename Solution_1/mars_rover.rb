#!/usr/bin/env ruby

=begin
Design: for this solution I decided to divide the problem into two sections.
Reading the data and a Rover class that is used to instantiate various rover
objects that have primarily "move" and "rotate" methods.

Assumptions: The ruby version used is 2.4.1.

Instructions:
Run this command in terminal:
ruby mars_rover.rb <path-to-data-file / data.tx>

A file with the same data format delivered in the test document must be provided
to compute the address of the rover.

The program prints on the screen a different response format than the one
requested in the test

=end
# Rover Class 
class Rover
  def initialize(initial_position, plateau)
    @grid_size = plateau.map(&:to_i)
    conversion = initial_position.split(' ')
    @coordinates = conversion[0..1].map(&:to_i)
    @rover_facing = conversion.last.capitalize
  end
  # List of all the commands for the rover to explore
  def commands(list)
    @commands = list.chars
  end

  # Navigate between all the commands and move or rotate accordingly
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

  # Using the class variable to turn left or right
  def rotate(command)
    turn = directions[@rover_facing]
    @rover_facing = command == 'L' ? turn.first : turn.last
  end

  # Move the rover on the grid based on the cardinal point it is facing
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

  # Validate if the rover moved outside the grid.
  def out_of_bounds?
    (0..@grid_size[0]).cover?(@coordinates[0]) &&
      (0..@grid_size[1]).cover?(@coordinates[1])
  end

  # Hash that allows to rotate. A cardinal point has an array
  # array[0] is a left turn, array[1] is a right turn.
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
      # Grid variable for rover to expllore
      @plateau = line[/(\d+\s\d+)\n/, 1].split(' ') unless line[/(\d+\s\d+)\n/, 1].nil?
      case line
      when /(\d+\s\d+\s[neswNESW])\n/
        # Initial coordenate of the rover
        @position_line = (line[/(\d+\s\d+\s[neswNESW])/])
      when /[MRL]+/
        # Initializating the rover
        rover = Rover.new(@position_line, @plateau)
        # Sending commands 
        rover.commands(line[/[MRL]+/])
        @num += 1
        # Exploring the plateau and printing results
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

