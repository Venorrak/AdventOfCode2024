require "awesome_print"
require 'absolute_time'

tests = []
nbOfRight = 0

def createInput(file_path)
  File.read(file_path).split("\n").map { |line| getTest(line) }
end

def getTest(line)
  numbers = line.split(":")[1].delete_prefix(" ").split(" ").map(&:to_i)
  test = {
    result: line.split(":")[0].to_i,
    numbers: numbers
  }
  return test
end

def getNbOfRight(test)
  operators = ["+", "*", "||"]
  # find the number of possible combinations where the result of the operations is equal to the result of the test
  # for each number in the test, we can either add or multiply it with the next number

  # if the test has only one number, we return 1 if the number is equal to the result, otherwise we return 0
  if test[:numbers].length == 1
    return test[:numbers][0] == test[:result] ? 1 : 0
  end

  possibilities = []
  possibility = {
    operations: [],
    result: test[:numbers][0]
  }
  possibilities.push(possibility)
  for i in 1..test[:numbers].length - 1
    newPossibilities = []
    possibilities.each do |oldPossibility|
      operators.each do |operator|
        if operator == "+"
          newResult = oldPossibility[:result] + test[:numbers][i]
        elsif operator == "*"
          newResult = oldPossibility[:result] * test[:numbers][i]
        else
          newResult = (oldPossibility[:result].to_s + test[:numbers][i].to_s).to_i
        end

        if newResult <= test[:result]
          newOperations = oldPossibility[:operations].clone
          newOperations.push(operator)
          newPossibility = {
            operations: newOperations,
            result: newResult
          }
          newPossibilities.push(newPossibility)
        end
      end
    end
    possibilities = newPossibilities
  end

  count = 0
  possibilities.each do |possibility|
    if possibility[:result] == test[:result]
      count += 1
    end
  end

  return count == 0 ? 0 : test[:result]
end

tests = createInput("input7.txt")

start = AbsoluteTime.now
tests.each_with_index do |test, index|
  nbOfRight += getNbOfRight(test)
  system("clear")
  puts "#{index + 1}/#{tests.length}" 
end
puts AbsoluteTime.now - start
ap nbOfRight
#3749
#11387