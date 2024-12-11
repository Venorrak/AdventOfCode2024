require 'concurrent'
require 'awesome_print'
require 'absolute_time'

def ParseInput(file_path)
  File.read(file_path).split(" ").map(&:to_i)
end

def evolve_stones(stones, blinks)
  stone_counts = Hash.new(0)
  stones.each { |stone| stone_counts[stone] += 1 }

  blinks.times do
    new_stone_counts = Hash.new(0)

    stone_counts.each do |stone, count|
      if stone == 0
        new_stone_counts[1] += count
      elsif stone.to_s.length.even?
        half = stone.to_s.length / 2
        left = stone.to_s[0...half].to_i
        right = stone.to_s[half..-1].to_i
        new_stone_counts[left] += count
        new_stone_counts[right] += count
      else
        new_stone_counts[stone * 2024] += count
      end
    end

    stone_counts = new_stone_counts
  end

  stone_counts
end

start = AbsoluteTime.now
stones = ParseInput("input11.txt")
ap evolve_stones(stones, 75).values.sum
ap AbsoluteTime.now - start