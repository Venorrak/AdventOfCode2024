require 'awesome_print'

map = nil
visitedCoordinates = []
startCoordinates = nil
insideTheMap = true

def createInput(file_path)
  File.read(file_path).split("\n").map { |line| line.split("") }
end

#map[y][x]
def getCoordinatesOfStart(map)
  map.each_with_index do |row, y|
    row.each_with_index do |column, x|
      if column == "^"
        return {
          x: x,
          y: y
        }
      end
    end
  end
end

def rotateVector(vector)
  # Rotate 90 degrees to the right
  case vector
  when {x: 0, y: -1}
    {x: 1, y: 0}
  when {x: 1, y: 0}
    {x: 0, y: 1}
  when {x: 0, y: 1}
    {x: -1, y: 0}
  when {x: -1, y: 0}
    {x: 0, y: -1}
  end
end

def showMap(map, visitedCoordinates)
  system("clear")
  map.each_with_index do |row, y|
    row.each_with_index do |column, x|
      if visitedCoordinates.include?({x: x, y: y})
        print "X"
      else
        print column
      end
    end
    puts
  end
end

def simulate_guard(map, startCoordinates, vector, loop_position)
  visitedCoordinates = []
  visitedStates = []
  visitedCoordinates.push(startCoordinates)
  currentCoordinates = startCoordinates
  insideTheMap = true
  nbLoops = 0

  while insideTheMap
    if nbLoops > 2
      return visitedCoordinates, true # Loop detected
    end

    nextY = currentCoordinates[:y] + vector[:y]
    nextX = currentCoordinates[:x] + vector[:x]

    if nextY < 0 || nextY >= map.size || nextX < 0 || nextX >= map[0].size
      insideTheMap = false
      next
    end

    if map[nextY][nextX] == "#"
      if loop_position != nil
        state = { coordinates: currentCoordinates, vector: vector }
        if visitedStates.include?(state)
          return visitedCoordinates, true # Loop detected
        else
          visitedStates.push(state)
        end
      end

      vector = rotateVector(vector)
      if loop_position != nil && loop_position[:x] == nextX && loop_position[:y] == nextY
        nbLoops += 1
      end
    else
      currentCoordinates = {x: nextX, y: nextY}
      unless visitedCoordinates.include?(currentCoordinates)
        visitedCoordinates.push(currentCoordinates)
      end
    end
  end

  return visitedCoordinates, false # No loop detected
end

map = createInput("input6.txt")
startCoordinates = getCoordinatesOfStart(map)
vector = {x: 0, y: -1}

visitedCoordinates, _ = simulate_guard(map, startCoordinates, vector, nil)
loop_positions = []

visitedCoordinates.each do |pos|
  p pos
  # Temporarily place an obstruction
  map[pos[:y]][pos[:x]] = "#"
  _, loop_detected = simulate_guard(map, startCoordinates, vector, pos)
  map[pos[:y]][pos[:x]] = "." # Remove the obstruction

  if loop_detected
    loop_positions.push(pos)
    p loop_positions.count
  end
end

ap visitedCoordinates.count
ap loop_positions.count