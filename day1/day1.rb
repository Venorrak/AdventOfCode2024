require 'awesome_print'

$leftList = []
$rightList = []
$totalDistance = 0
$totalSimilarity = 0
$hashOfRight = {}

def createLists()
  File.open("input1.txt").each do |line|
    sides = line.split("   ")
    $leftList.push(sides[0].to_i)
    $rightList.push(sides[1].to_i)
  end
end

def orderLists()
  $leftList.sort!
  $rightList.sort!
end

def createHashOfRight()
  $rightList.each do |right|
    if $hashOfRight[right].nil?
      $hashOfRight[right] = 1
    else
      $hashOfRight[right] += 1
    end
  end
end

createLists()
orderLists()
createHashOfRight()

$leftList.count.times do |i|
  distance = $leftList[i] - $rightList[i]
  distance = distance.abs
  $totalDistance += distance
  
  if !$hashOfRight[$leftList[i]].nil?
    $totalSimilarity += $hashOfRight[$leftList[i]] * $leftList[i]
  end
end



p $totalDistance
p $totalSimilarity