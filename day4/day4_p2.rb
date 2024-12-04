require 'awesome_print'
require 'set'

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
  turnedLines = lines.transpose
  return turnedLines
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

  reversedLines = lines.reverse

  reversedLines.each_with_index do |line, y|
    line.each_with_index do |char, x|
      # y=0, x=0 -> diagonalIndex = (diagonals.length / 2).floor + ( y - x )
      diagonals[(diagonals.length / 2).floor + ( y - x )].push(char)
    end
  end
  return diagonals
end

def getNBOfXmas(diagonal, reverseDiagonal, nbOfLines)
  diagonalStrings = []
  reverseDiagonalStrings = []
  numberOfXMAS = 0

  diagonal.each do |line|
    diagonalStrings.push(line.join(""))
  end

  reverseDiagonal.each do |line|
    reverseDiagonalStrings.push(line.join(""))
  end

  diagonalMas = Set.new
  reverseDiagonalMas = Set.new
  diagonalStrings.each_with_index do |line, lineIndex|
    startPosInDiags = line.enum_for(:scan, /MAS/).map { Regexp.last_match.begin(0) }
    startPosInDiags2 = line.enum_for(:scan, /SAM/).map { Regexp.last_match.begin(0) }
    startPosInDiags.map! { |pos| pos + 1 }
    startPosInDiags2.map! { |pos| pos + 1 }

    startPosInDiags.each do |pos|
      if lineIndex < nbOfLines - 1
        y = (nbOfLines - 1) + pos
        x = pos
      else
        y = pos
        x = (lineIndex - (nbOfLines - 1)) + pos
      end
      diagonalMas.add({x: x, y: y})
    end
    startPosInDiags2.each do |pos|
      if lineIndex < nbOfLines - 1
        y = (nbOfLines - 1) + pos
        x = pos
      else
        y = pos
        x = (lineIndex - (nbOfLines - 1)) + pos
      end
      diagonalMas.add({x: x, y: y})
    end
  end

  reverseDiagonalStrings.each_with_index do |line, lineIndex|
    startPosInDiags = line.enum_for(:scan, /MAS/).map { Regexp.last_match.begin(0) }
    startPosInDiags2 = line.enum_for(:scan, /SAM/).map { Regexp.last_match.begin(0) }
    startPosInDiags.map! { |pos| pos + 1 }
    startPosInDiags2.map! { |pos| pos + 1 }

    startPosInDiags.each do |pos|
      if lineIndex < nbOfLines
        x = (nbOfLines - 1) - lineIndex + pos
        y = (nbOfLines - 1) - pos
      else
        y = ((nbOfLines - 1) - lineIndex) + ((nbOfLines - 1) - pos)
        x = pos
      end
      reverseDiagonalMas.add({x: x, y: y})
    end
    startPosInDiags2.each do |pos|
      if lineIndex < nbOfLines
        x = (nbOfLines - 1) - lineIndex + pos
        y = (nbOfLines - 1) - pos
      else
        y = ((nbOfLines - 1) - lineIndex) + ((nbOfLines - 1) - pos)
        x = pos
      end
      reverseDiagonalMas.add({x: x, y: y})
    end
  end

  ap diagonalMas
  # p reverseDiagonalMas
  diagonalMas.each_with_index do |mas, index|
    if diagonalMas.count(mas) > 1
      puts "Duplicate found at index #{index}: #{mas}"
    end
  end

  common_mas = diagonalMas & reverseDiagonalMas
  numberOfXMAS = common_mas.size

  return numberOfXMAS
end

lines = createReport("input4.txt")

horizontal = getHorizontal(lines)
diagonal = getDiagonal(horizontal)
reverseDiagonal = getReverseDiagonal(horizontal)


p getNBOfXmas(diagonal, reverseDiagonal, horizontal.count)
