require 'awesome_print'
require 'absolute_time'

def ParseInput(file_path)
  File.read(file_path).split("\n").map { |line| line.split("").map(&:to_i)}
end

def findTrailHeads(input)
  trailHeads = []
  input.each_with_index do |row, y|
    row.each_with_index do |column, x|
      if column == 0
        trailHeads.push({
          x: x,
          y: y
        })
      end
    end
  end
  return trailHeads
end

def isNotOnBottom(input, position)
  return position[:y] + 1 < input.length
end

def isNotOnRight(input, position)
  return position[:x] + 1 < input[0].length
end

def isNotOnLeft(input, position)
  return position[:x] - 1 >= 0
end

def isNotOnTop(input, position)
  return position[:y] - 1 >= 0
end

def findAdjacent(positions, targetNumber, grid)
  newPositions = []
  positions.each do |position|
    if isNotOnBottom(grid, position) && grid[position[:y] + 1][position[:x]] == targetNumber
      newPositions.push({
        x: position[:x],
        y: position[:y] + 1
      })
    end
    if isNotOnRight(grid, position) && grid[position[:y]][position[:x] + 1] == targetNumber
      newPositions.push({
        x: position[:x] + 1,
        y: position[:y]
      })
    end
    if isNotOnLeft(grid, position) && grid[position[:y]][position[:x] - 1] == targetNumber
      newPositions.push({
        x: position[:x] - 1,
        y: position[:y]
      })
    end
    if isNotOnTop(grid, position) && grid[position[:y] - 1][position[:x]] == targetNumber
      newPositions.push({
        x: position[:x],
        y: position[:y] - 1
      })
    end
  end
  return newPositions.uniq
end

def getNumberOfPaths(trailHead, input)
  region = {
    1 => [],
    2 => [],
    3 => [],
    4 => [],
    5 => [],
    6 => [],
    7 => [],
    8 => [],
    9 => [],
  }
  region[1] = findAdjacent([trailHead], 1, input)
  for i in 2..9 do
    region[i] = findAdjacent(region[i - 1], i, input)
  end
  return region[9].length
end

start = AbsoluteTime.now
input = ParseInput("input10.txt")
trailHeads = findTrailHeads(input)
total = 0

trailHeads.each do |trailHead|
  total += getNumberOfPaths(trailHead, input)
end
ap AbsoluteTime.now - start
ap total
#36