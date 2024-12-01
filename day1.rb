require 'awesome_print'

$leftList = []
$rightList = []
$totalDistance = 0
$totalSimilarity = 0

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

createLists()
orderLists()

$leftList.count.times do |i|
  distance = $leftList[i] - $rightList[i]
  if distance < 0
    distance = distance * -1
  end
  $totalDistance += distance

  nbOfSame = 0
  $rightList.each do |right|
    if $leftList[i] == right
      nbOfSame += 1
    end
  end
  $totalSimilarity += nbOfSame * $leftList[i]
end



p $totalDistance
p $totalSimilarity