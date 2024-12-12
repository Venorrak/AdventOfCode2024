require 'awesome_print'
require 'absolute_time'


def ParseInput(file_path)
  File.read(file_path).split("\n").map { |line| line.split("") }
end


$SideTemplate = Struct.new(:coordinates, :vertical, :after)
$regionTemplate = Struct.new(:squares, :perimeter, :area, :type, :sides)
# to calculate the perimeter, each square has a perimeter of 4, but if it's adjacent to another square, it loses 1 perimeter
# to calculate the area, we can just count the number of squares

def calculate_perimeter(region, squares)
  region.squares.each do |square|
    y, x = square
    adjacents = [[y, x - 1], [y, x + 1], [y - 1, x], [y + 1, x]]

    adjacents = adjacents.reject { |adjacent| adjacent[0] < 0 || adjacent[1] < 0 || adjacent[0] >= squares.length || adjacent[1] >= squares[0].length }
    region.perimeter += (4 - adjacents.length)
    adjacents.each do |adjacent|
      region.perimeter += 1 if squares[adjacent[0]][adjacent[1]] != region.type
    end
  end
end

def calculate_sides(region, squares)
  xmin = region.squares.map { |square| square[1] }.min
  xmax = region.squares.map { |square| square[1] }.max
  ymin = region.squares.map { |square| square[0] }.min
  ymax = region.squares.map { |square| square[0] }.max

  #check for vertical sides
  for x in xmin..xmax
    for y in ymin..ymax
      if region.squares.include?([y, x])
        if !region.squares.include?([y,x-1])
          existing_side = region.sides.find { |side| side.coordinates.include?([y+1, x]) && side.vertical == true && side.after == false || side.coordinates.include?([y-1, x]) && side.vertical == true && side.after == false }
          if existing_side
            existing_side.coordinates << [y, x]
          else
            region.sides << $SideTemplate.new([[y, x]], true, false)
          end
        end

        if !region.squares.include?([y, x+1]) || squares[0].length - 1 == x
          existing_side = region.sides.find { |side| side.coordinates.include?([y-1, x+1]) && side.vertical == true && side.after == true || side.coordinates.include?([y+1, x+1]) && side.vertical == true && side.after == true }
          if existing_side
            existing_side.coordinates << [y, x+1]
          else
            region.sides << $SideTemplate.new([[y, x+1]], true, true)
          end
        end
      end
    end
  end

  #check for horizontal sides
  for y in ymin..ymax
    for x in xmin..xmax
      if region.squares.include?([y, x])
        if !region.squares.include?([y-1, x])
          existing_side = region.sides.find { |side| side.coordinates.include?([y, x+1]) && side.vertical == false && side.after == false || side.coordinates.include?([y, x-1]) && side.vertical == false && side.after == false }
          if existing_side
            existing_side.coordinates << [y, x]
          else
            region.sides << $SideTemplate.new([[y, x]], false, false)
          end
        end

        if !region.squares.include?([y+1, x]) || squares.length - 1 == y
          existing_side = region.sides.find { |side| side.coordinates.include?([y+1, x-1]) && side.vertical == false && side.after == true || side.coordinates.include?([y+1, x+1]) && side.vertical == false && side.after == true }
          if existing_side
            existing_side.coordinates << [y+1, x]
          else
            region.sides << $SideTemplate.new([[y+1, x]], false, true)
          end
        end
      end
    end
  end
end

def calculate_region(squares, x, y)
  region = $regionTemplate.new([], 0, 0, squares[y][x], [])
  queue = [[y, x]]

  while queue.length > 0
    y, x = queue.shift
    adjacents = [[y, x - 1], [y, x + 1], [y - 1, x], [y + 1, x]]
    adjacents = adjacents.reject { |adjacent| adjacent[0] < 0 || adjacent[1] < 0 || adjacent[0] >= squares.length || adjacent[1] >= squares[0].length || region.squares.include?(adjacent) || queue.include?(adjacent) }

    region.squares << [y, x]
    region.area += 1

    adjacents.each do |adjacent|
      queue << adjacent if squares[adjacent[0]][adjacent[1]] == region.type
    end
  end
  calculate_perimeter(region, squares)
  calculate_sides(region, squares)
  region
end

def count_regions(squares)
  regions = []
  squares.each_with_index do |row, y|
    row.each_with_index do |square, x|
      regions.any? { |region| region.squares.include?([y, x]) } && next
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
    total_cost += region.area * region.sides.count
  end
  total_cost
end


start = AbsoluteTime.now
input = ParseInput("input12.txt")
regions = count_regions(input)
cost = calculate_cost(regions)
p AbsoluteTime.now - start
ap cost