#!/usr/bin/env ruby

=begin

Design: for this second solution I just compressed the whole solution in a more
minimalist way just using simple methods.

Assumptions: The ruby version used is 2.4.1.

Instructions:
Run this command in terminal:
ruby mars_rover.rb <path-to-data-file / data.tx>

A file with the same data format as delivered in the test document must be
provided.
to calculate the direction of the mobile.

The program prints the response format shown in the document on the screen. In
case the data or the file is not in the established format, the program will
not output anything.

=end


# Moving the rover
def move
  @coordinates[1] += 1 if @rover_facing == 'N'
  @coordinates[0] += 1 if @rover_facing == 'E'
  @coordinates[1] -= 1 if @rover_facing == 'S'
  @coordinates[0] -= 1 if @rover_facing == 'W'
end

# Rotaring the rover
def rotate(command)
  directions = {
    'N' => %w[W E],
    'E' => %w[N S],
    'S' => %w[E W],
    'W' => %w[S N]
  }
  turn = directions[@rover_facing]
  @rover_facing = command == 'L' ? turn.first : turn.last
end

# When out of bounds
def out_of_bounds?
  (0..@grid_size[0]).cover?(@coordinates[0]) &&
    (0..@grid_size[1]).cover?(@coordinates[1])
end

@num = 0
unless (ARGV[0]).nil?
  File.foreach(ARGV[0]) do |line|
    @grid_size = line[/(\d+\s\d+)\n/, 1].split(' ').map(&:to_i) unless line[/(\d+\s\d+)\n/, 1].nil?
    case line
    when /(\d+\s\d+\s[neswNESW])\n/
      @coordinates = (line[/(\d+\s\d+\s[neswNESW])/]).split(' ')[0..1].map(&:to_i)
      @rover_facing = (line[/(\d+\s\d+\s[neswNESW])/]).split(' ').last.capitalize
    when /[MRL]+/
      (line[/[MRL]+/]).chars.each do |command|
        break unless out_of_bounds?
        command == 'M' ? move : rotate(command)
      end
      if !out_of_bounds?
        puts ''
      else
        @num += 1
        puts @coordinates.map(&:to_s).join(' ') + ' ' + @rover_facing.to_s
      end
    else
      next
    end
  end
end
