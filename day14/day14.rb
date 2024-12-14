require 'awesome_print'
require 'absolute_time'

$vectorTemplate = Struct.new(:x, :y)
$robotTemplate = Struct.new(:position, :direction)
$gridTemplate = Struct.new(:width, :height, :file_path)
files = []
files << $gridTemplate.new(101, 103, 'input14.txt')
files << $gridTemplate.new(11, 7, 'test.txt')

def parseInput(file_path)
  File.read(file_path.file_path).split("\n").map { |line| parseRobot(line) }
end

def parseRobot(line)
  position, direction = line.split(" ")
  position = position.delete_prefix("p=").split(",").map { |coord| coord.to_i }
  direction = direction.delete_prefix("v=").split(",").map { |coord| coord.to_i }
  $robotTemplate.new($vectorTemplate.new(position[0], position[1]), $vectorTemplate.new(direction[0], direction[1]))
end

def processRobot(robot, file_path)
  x, y = robot.position.x, robot.position.y
  dx, dy = robot.direction.x, robot.direction.y
  robot.position.x = (x + dx) % file_path.width
  robot.position.y = (y + dy) % file_path.height
end

def calculateRobotsInQuadrants(robots, file)
  quadrants = [[], [], [], []]
  robots.each do |robot|
    x, y = robot.position.x, robot.position.y
    dx, dy = robot.direction.x, robot.direction.y
    if x < file.width / 2 && y < file.height / 2
      quadrants[0] << robot
    elsif x > file.width / 2 && y < file.height / 2
      quadrants[1] << robot
    elsif x < file.width / 2 && y > file.height / 2
      quadrants[2] << robot
    elsif x > file.width / 2 && y > file.height / 2
      quadrants[3] << robot
    end
  end
  safety_factor = quadrants[0].length
  for i in 1..3
    safety_factor *= quadrants[i].length 
  end
  safety_factor
end

def displayRobots(robots, file)
  system "clear"
  string = ""
  file.height.times do |y|
    file.width.times do |x|
      robot = robots.find { |robot| robot.position.x == x && robot.position.y == y }
      if robot
        string += "o"
      else
        string += "."
      end
    end
    string += "\n"
  end
  puts string
end

def highConcentrationOfRobots(robots, file)
  robots.each do |robot|
    count = robots.count do |r|
      (r.position.x - robot.position.x).abs <= 1 && (r.position.y - robot.position.y).abs <= 1
    end
    return true if count > 8
  end
  false
end


current_file = files[0]
start = AbsoluteTime.now
robots = parseInput(current_file)
100.times do |i|
  robots.each do |robot|
    processRobot(robot, current_file)
  end
  # if highConcentrationOfRobots(robots, current_file)
  #   displayRobots(robots, current_file)
  #   p i + 1
  #   gets
  # end
end
ap calculateRobotsInQuadrants(robots, current_file)
p "Time: #{AbsoluteTime.now - start}"


