require 'awesome_print'

grid = []
$antiNodes = []

def createInput(file_path)
  File.read(file_path).split("\n").map { |line| line.split("") }
end

def getNodes(grid)
  nodes = {}
  grid.each_with_index do |row, y|
    row.each_with_index do |column, x|
      if column != "."
        if nodes["#{column}"].nil?
          nodes["#{column}"] = []
        end
        nodes["#{column}"].push({
          x: x,
          y: y,
        })
        $antiNodes.push({
          x: x,
          y: y
        })
      end
    end
  end
  return nodes
end

def getGridDimensions(grid)
  return {
    width: grid[0].length,
    height: grid.length
  }
end

def isOutOfBounds(x, y, size)
  return x < 0 || y < 0 || x >= size[:width] || y >= size[:height]
end

def getNbOfAntiNodes(nodes, size)
  nodes.each do |key, value|
    if value.length > 1
      getNbOfAntiNodesForFrequency(value, size)
    end
  end
end

def getNbOfAntiNodesPerCombination(node1, node2, diffPos, size)
  diffPosForce = diffPos[:x].abs + diffPos[:y].abs
  sizeForce = size[:width] + size[:height]
  nbOfLong = (sizeForce.to_f / diffPosForce.to_f).to_i
  for i in 1..nbOfLong

    if !isOutOfBounds(node1[:x] + (diffPos[:x] * i), node1[:y] + (diffPos[:y] * i), size)
      if node1[:x] + (diffPos[:x] * i) != node2[:x] && node1[:y] + (diffPos[:y] * i) != node2[:y]
        $antiNodes.push({
          x: node1[:x] + (diffPos[:x] * i) ,
          y: node1[:y] + (diffPos[:y] * i)
        })
      end
    end

    if !isOutOfBounds(node2[:x] - (diffPos[:x] * i), node2[:y] - (diffPos[:y] * i), size)
      if node2[:x] - (diffPos[:x] * i) != node1[:x] && node2[:y] - (diffPos[:y] * i) != node1[:y]
        $antiNodes.push({
          x: node2[:x] - (diffPos[:x] * i),
          y: node2[:y] - (diffPos[:y] * i)
        })
      end
    end

  end
end

def getNbOfAntiNodesForFrequency(nodes, size)
  nodes.combination(2).each do |node1, node2|
    diffPos = {
      x: node1[:x] - node2[:x],
      y: node1[:y] - node2[:y]
    }
    getNbOfAntiNodesPerCombination(node1, node2, diffPos, size)
  end
end

def showGridWithAntiNodes(grid, antiNodes)
  thisGrid = grid.clone
  thisGrid.each_with_index do |row, y|
    row.each_with_index do |column, x|
      if antiNodes.any? { |node| node[:x] == x && node[:y] == y }
        print "#"
      else
        print column
      end
    end
    print "\n"
  end
end

grid = createInput("input8.txt")
nodes = getNodes(grid)
size = getGridDimensions(grid)
getNbOfAntiNodes(nodes, size)

$antiNodes.uniq!
p $antiNodes.length

showGridWithAntiNodes(grid, $antiNodes)

# 14
# 34