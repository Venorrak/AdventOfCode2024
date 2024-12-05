require 'awesome_print'
rules = nil
updates = nil
totalOfValidCenters = 0
totalOfInvalidCenters = 0
invalidUpdates = []

def createInput(file_path)
  parts = File.read(file_path).split("\n\n")
  rules = parts[0].split("\n").map { |rule| rule.split("|").map(&:to_i) }
  updates = parts[1].split("\n").map { |update| update.split(",").map(&:to_i) }
  return rules, updates
end

def isUpdateValid?(update, rules)
  rules.each do |rule|
    if update.include?(rule[0]) && update.include?(rule[1])
      if update.index(rule[0]) > update.index(rule[1])
        return false
      end
    end
  end
  return true
end

def getCenterOfUpdate(update)
  centerIndex = (update.count / 2).floor
  return update[centerIndex]
end

def orderUpdate(update, rules)
  orderedUpdate = update.dup
  rules.each do |rule|
    if update.include?(rule[0]) && update.include?(rule[1])
      if update.index(rule[0]) > update.index(rule[1])
        # move update[update.index(rule[0])] to the left of update[update.index(rule[1])]
        while update.index(rule[0]) > update.index(rule[1])
          originalIndex = update.index(rule[0])
          temp = update[originalIndex]
          update[originalIndex] = update[originalIndex - 1]
          update[originalIndex - 1] = temp
        end
      end
    end
  end
  return orderedUpdate
end

rules, updates = createInput("input5.txt")

updates.each do |update|
  if isUpdateValid?(update, rules)
    totalOfValidCenters += getCenterOfUpdate(update)
  else
    invalidUpdates.push(update)
  end
end

invalidUpdates.each do |invalidUpdate|
  orderedUpdate = invalidUpdate.dup
  until isUpdateValid?(orderedUpdate, rules)
    orderedUpdate = orderUpdate(invalidUpdate, rules)
  end
  totalOfInvalidCenters += getCenterOfUpdate(orderedUpdate)
end

p totalOfValidCenters
p totalOfInvalidCenters
