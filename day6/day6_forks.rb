require 'awesome_print'
require 'socket'
require 'json'

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

def getWorkerMessage(worker)
  readable, _, _ = IO.select([worker], nil, nil, 1)
  if readable
    message = worker.read_nonblock(1024).chomp
    message = message.split("\n")
    return message
  end
end

def closeWorker(worker)
  worker[1].puts [].to_json
  worker[1].close
end

map = createInput("input6.txt")
startCoordinates = getCoordinatesOfStart(map)
vector = {x: 0, y: -1}

visitedCoordinates, _ = simulate_guard(map, startCoordinates, vector, nil)

workers = []
batches = []
server = UNIXServer.new("mysock")
nbOfForks = 10
nbOfLoops = 0

acceptWorkerThread = Thread.start do
  nbOfForks.times do
    worker = server.accept
    worker = [0, worker]
    workers.push(worker)
  end
end

getDataWorkerThread = Thread.start do
  loop do
    workers.each do |worker|
      if worker[0] == 1
        message = getWorkerMessage(worker[1])
        if !message.nil?
          message.each do |mes|
            nbOfLoops += mes.to_i
            if mes.to_i == 0
              p "received all data"
              worker[0] = 0
            else
              p nbOfLoops
            end
          end
        end
      end
    end
  end
end

nbOfForks.times do
  thisFork = fork do
    server.close
    worker = UNIXSocket.new("mysock")
    loop do
      bundle = JSON.parse(worker.gets)
      if bundle == []
        worker.close
        break
      else
        bundle.each do |pos|
          # p pos
          map[pos["y"]][pos["x"]] = "#"
          _, loop_detected = simulate_guard(map, startCoordinates, vector, pos)
          map[pos["y"]][pos["x"]] = "."
          if loop_detected
            worker.puts "1"
          end
        end
        worker.puts "0"
      end
    end
  end
end

acceptWorkerThread.join

batch_size = (visitedCoordinates.count / nbOfForks)
batches = visitedCoordinates.each_slice(batch_size).to_a
if batches.size > nbOfForks
  until batches.size <= nbOfForks
    last_batch = batches.pop
    batches.last.concat(last_batch)
  end
end

batches.each_with_index do |batch, index|
  workers[index][1].puts batch.to_json
  workers[index][0] = 1
end



ap visitedCoordinates.count
until workers.empty?
  workers.each do |worker|
    if worker[0] == 0
      p "Closing worker"
      closeWorker(worker)
      workers.delete(worker)
    end
  end
end
ap nbOfLoops

`rm mysock`