require 'awesome_print'

horizontal = []
vertical = []
bottomToTop = []
diagonal = []
reverseDiagonal = []

def createReport(file_path)
  File.read(file_path).split("\n")
end

def getHorizontal(lines)
  hor = []
  lines.each do |line|
    hor.push(line.split(""))
  end
  return hor
end

def getvertical(lines)
  lines.transpose
end

def getDiagonal(lines)
  diagonals = []
  (1 + ((lines.length - 1) * 2)).times do |i|
    diagonals.push([])
  end


  lines.each_with_index do |line, y|
    line.each_with_index do |char, x|
      # y=0, x=0 -> diagonalIndex = (diagonals.length / 2).floor - ( y - x )
      diagonals[(diagonals.length / 2).floor - ( y - x )].push(char)
    end
  end
  return diagonals
end

def getReverseDiagonal(lines)
  diagonals = []
  (1 + ((lines.length - 1) * 2)).times do |i|
    diagonals.push([])
  end

  lines.reverse!

  lines.each_with_index do |line, y|
    line.each_with_index do |char, x|
      # y=0, x=0 -> diagonalIndex = (diagonals.length / 2).floor + ( y - x )
      diagonals[(diagonals.length / 2).floor + ( y - x )].push(char)
    end
  end
  return diagonals
end

def getNBOfXmas(lines)
  lineStrings = []
  numberOfXMAS = 0
  lines.each do |line|
    lineStrings.push(line.join(""))
  end
  lineStrings.each do |line|
    numberOfXMAS += line.scan(/XMAS/).count
    numberOfXMAS += line.scan(/SAMX/).count
  end
  return numberOfXMAS
end

lines = createReport("input4.txt")

horizontal = getHorizontal(lines)
vertical = getvertical(horizontal)
diagonal = getDiagonal(horizontal)
reverseDiagonal = getReverseDiagonal(horizontal)

numberOfXMAS = 0
numberOfXMAS += getNBOfXmas(horizontal)
numberOfXMAS += getNBOfXmas(vertical)
numberOfXMAS += getNBOfXmas(diagonal)
numberOfXMAS += getNBOfXmas(reverseDiagonal)
p numberOfXMAS
