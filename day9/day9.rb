require 'awesome_print'
require 'absolute_time'

def ParseInput(file_path)
  File.read(file_path).split("").map(&:to_i)
end

def getArrayWithSpace(array)
  stringArray = []
  files = []
  freeSpace = []
  indexAt = 0

  array.each_with_index do |number, index|
    if index % 2 == 0
      files.push({
        value: indexAt,
        size: number,
        startAt: stringArray.length
      })
      
      number.times do
        stringArray.push(indexAt)
      end
      
      indexAt += 1
    else
      freeSpace.push({
        size: number,
        startAt: stringArray.length
      })

      number.times do
        stringArray.push(".")
      end
    end
  end
  return stringArray, files.reverse, freeSpace
end

def sortStringArray(stringArray, files, freeSpace)
  files.each do |file|
    freeSpace.each do |space|
      if space[:size] >= file[:size] && file[:startAt] >= space[:startAt]
        file[:size].times do |index|
          stringArray[space[:startAt] + index] = file[:value]
          stringArray[file[:startAt] + index] = "."
        end
        space[:size] -= file[:size]
        space[:startAt] += file[:size]
        break
      end
    end
  end
  return stringArray
end

def getSolution(sortedArray)
  count = 0
  sortedArray.each_with_index do |number, index|
    count += number.to_i * index
  end
  return count
end

start = AbsoluteTime.now
input = ParseInput("input9.txt")
stringArray, files, freeSpace = getArrayWithSpace(input)
sortedArray = sortStringArray(stringArray, files, freeSpace)
solution = getSolution(sortedArray)
p AbsoluteTime.now - start

p solution