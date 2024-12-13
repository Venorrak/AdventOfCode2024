require 'awesome_print'
require 'absolute_time'

$vectorTemplate = Struct.new(:x, :y)
$possibilitieTemplate = Struct.new(:A, :B, :cost)
$machineTemplate = Struct.new(:prize, :AVec, :BVec, :possibilities)

def parseBtnA(line)
  xy = line.delete_prefix("Button A: ").split(", ")
  x = xy[0].delete_prefix("X+").to_i
  y = xy[1].delete_prefix("Y+").to_i
  return $vectorTemplate.new(x, y)
end

def parseBtnB(line)
  xy = line.delete_prefix("Button B: ").split(", ")
  x = xy[0].delete_prefix("X+").to_i
  y = xy[1].delete_prefix("Y+").to_i
  return $vectorTemplate.new(x, y)
end

def parsePrize(line)
  xy = line.delete_prefix("Prize: ").split(", ")
  x = xy[0].delete_prefix("X=").to_i + 10000000000000
  y = xy[1].delete_prefix("Y=").to_i + 10000000000000
  return $vectorTemplate.new(x, y)
end

def parseInput(file_path)
  machines = File.read(file_path).split("\n\n")
  parsed_machines = []
  machines.each do |machine|
    parsed_machines << $machineTemplate.new(
      parsePrize(machine.split("\n")[2]),
      parseBtnA(machine.split("\n")[0]),
      parseBtnB(machine.split("\n")[1]),
      []
    )
  end
  return parsed_machines
end

def possibilitiesByCost(machine)
  least = [ machine.AVec.x, machine.AVec.y, machine.BVec.x, machine.BVec.y ].min
  biggestPrize = [ machine.prize.x, machine.prize.y ].max
  possibilities = (0..(biggestPrize / least)).to_a.permutation(2).to_a.map { |x, y| $possibilitieTemplate.new(x, y, (x * 3) + y) }
  possibilities.sort_by!(&:cost)
  p possibilities
  return possibilities
end

def findMachinePossibilites(machine)
  (0..100).each do |x|
    (0..100).each do |y|
      predicted_x = machine.AVec.x * x + machine.BVec.x * y
      predicted_y = machine.AVec.y * x + machine.BVec.y * y
      if predicted_x == machine.prize.x && predicted_y == machine.prize.y
        cost = (x * 3) + y
        machine.possibilities << $possibilitieTemplate.new(x, y, cost)
      end
    end
  end
end

def findLowestCostPossibility(machine)
  if machine.possibilities.length == 0
    return 0
  end
  costs = machine.possibilities.map { |possibility| possibility.cost }
  return costs.min
end

start = AbsoluteTime.now
machines = parseInput("test.txt")
possibilitiesByCost(machines.first)
machines.each do |machine|
  findMachinePossibilites(machine)
end

total_cost = 0
machines.each do |machine|
  total_cost += findLowestCostPossibility(machine)
end
p AbsoluteTime.now - start
ap total_cost
