require 'awesome_print'
require 'absolute_time'

$vectorTemplate = Struct.new(:x, :y)

def parseInput(file_path)
  parts = File.read(file_path).split("\n\n")
  grid = parts[0].split("\n").map { |line| line.split("") }
  moves = []
  parts[1].split("\n").each do |line|
    moves += line.split("")
  end
  [grid, moves]
end

def findFish(grid)
  fish = nil
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell == "@"
        fish = $vectorTemplate.new(x, y)
      end
    end
  end
  fish
end

def doMove(move, grid, fish)
  direction = $vectorTemplate.new(0, 0)
  case move
  when "^"
    direction.y -= 1
  when "v"
    direction.y += 1
  when "<"
    direction.x -= 1
  when ">"
    direction.x += 1
  end

  boxPosition = nil
  case grid[fish.y + direction.y][fish.x + direction.x]
  when "."
    grid[fish.y + direction.y][fish.x + direction.x] = "@"
    grid[fish.y][fish.x] = "."
    fish.x += direction.x
    fish.y += direction.y
    return
  when "#"
    return
  when "O"
    boxPosition = $vectorTemplate.new(fish.x + direction.x, fish.y + direction.y)
  when "@"
    p "error two fish"
    showGrid(grid)
    exit
  end

  i = 0
  inloop = true
  while inloop
    # p i
    dy = direction.y
    if direction.y > 0
      dy += i
    elsif direction.y < 0
      dy -= i
    end

    dx = direction.x
    if direction.x > 0
      dx += i
    elsif direction.x < 0
      dx -= i
    end
    lookingAt = $vectorTemplate.new(fish.x + dx,fish.y + dy)
    case grid[lookingAt.y][lookingAt.x]
    when "#"
      inloop = false
    when "."
      grid[boxPosition.y][boxPosition.x] = "."
      grid[lookingAt.y][lookingAt.x] = "O"
      grid[fish.y + direction.y][fish.x + direction.x] = "@"
      grid[fish.y][fish.x] = "."
      fish.x += direction.x
      fish.y += direction.y
      inloop = false
    end
    i += 1
  end
end

def showGrid(grid)
  grid.each do |row|
    puts row.join("")
  end
end

def getAllBoxes(grid)
  boxes = []
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell == "O"
        boxes << $vectorTemplate.new(x, y)
      end
    end
  end
  boxes
end

grid, moves = parseInput('input15.txt')
fish = findFish(grid)


moves.each do |move|
  doMove(move, grid, fish)
end

boxes = getAllBoxes(grid)
result = 0
boxes.each do |box|
  result += 100 * box.y + box.x
end

p result
showGrid(grid)

#10092