require 'awesome_print'
require 'absolute_time'

def ParseInput(file_path)
  File.read(file_path).split("\n").map { |line| line.split("") }
end

$regionTemplate = Struct.new(:squares, :perimeter, :area, :type)
# to calculate the perimeter, each square has a perimeter of 4, but if it's adjacent to another square, it loses 1 perimeter
# to calculate the area, we can just count the number of squares

def calculate_perimeter(region, squares)
  region.squares.each do |square|
    x, y = square
    adjacents = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]

    adjacents = adjacents.reject { |adjacent| adjacent[0] < 0 || adjacent[1] < 0 || adjacent[0] >= squares.length || adjacent[1] >= squares[0].length }
    region.perimeter += (4 - adjacents.length)
    adjacents.each do |adjacent|
      region.perimeter += 1 if squares[adjacent[0]][adjacent[1]] != region.type
    end
  end
end

def calculate_region(squares, x, y)
  region = $regionTemplate.new([], 0, 0, squares[x][y])
  queue = [[x, y]]

  while queue.length > 0
    x, y = queue.shift
    adjacents = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    adjacents = adjacents.reject { |adjacent| adjacent[0] < 0 || adjacent[1] < 0 || adjacent[0] >= squares.length || adjacent[1] >= squares[0].length || region.squares.include?(adjacent) || queue.include?(adjacent) }

    region.squares << [x, y]
    region.area += 1

    adjacents.each do |adjacent|
      queue << adjacent if squares[adjacent[0]][adjacent[1]] == region.type
    end
  end
  calculate_perimeter(region, squares)
  region
end

def count_regions(squares)
  regions = []
  squares.each_with_index do |row, x|
    row.each_with_index do |square, y|
      regions.any? { |region| region.squares.include?([x, y]) } && next
      # p "x: #{x}, y: #{y}"

      region = calculate_region(squares, x, y)
      regions << region
    end
  end

  regions
end

def calculate_cost(regions)
  total_cost = 0
  regions.each do |region|
    total_cost += region.area * region.perimeter
  end
  total_cost
end


start = AbsoluteTime.now
input = ParseInput("input12.txt")
regions = count_regions(input)
cost = calculate_cost(regions)
p AbsoluteTime.now - start

ap cost

# test = 1930