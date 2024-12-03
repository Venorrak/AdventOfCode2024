require 'awesome_print'

muls = []

def createReport(file_path)
  File.read(file_path).split("\n").join("")
end

def getDoDont(input)
  do_regex = /do\(\)/
  dont_regex = /don't\(\)/
  dos = input.scan(do_regex)
  donts = input.scan(dont_regex)
  doPos = input.enum_for(:scan, do_regex).map { Regexp.last_match.begin(0) }
  dontPos = input.enum_for(:scan, dont_regex).map { Regexp.last_match.begin(0) }
  doWithPos = []
  # create an array of hashes containing the do as true and don't as false in order of pos
  (dos.count + donts.count).times do |i|
    if doPos[0].nil?
      doWithPos.push({do: false, pos: dontPos[0]})
      dontPos.shift
      next
    elsif dontPos[0].nil?
      doWithPos.push({do: true, pos: doPos[0]})
      doPos.shift
      next
    end
    if doPos[0] < dontPos[0]
      doWithPos.push({do: true, pos: doPos[0]})
      doPos.shift
    else
      doWithPos.push({do: false, pos: dontPos[0]})
      dontPos.shift
    end
  end
  return doWithPos
end

def getMuls(input)
  regex = /mul\(\d{1,3},\d{1,3}\)/
  muls = input.scan(regex)
  mulsPos = input.enum_for(:scan, regex).map { Regexp.last_match.begin(0) }
  mulsWithPos = []
  muls.each_with_index do |mul, i|
    mulWithPos = {
      mul: mul,
      pos: mulsPos[i]
    }
    mulsWithPos.push(mulWithPos)
  end
  return mulsWithPos
end

def solveMul(mul)
  mul = mul.delete_prefix("mul(")
  mul = mul.delete_suffix(")")
  mul = mul.split(",")
  mul[0].to_i * mul[1].to_i
end

input = createReport("input3.txt")
muls = getMuls(input)
doDont = getDoDont(input)
result = 0

muls.each do |mul|
  lastDoDont = doDont.select { |doDont| doDont[:pos] < mul[:pos] }.last
  if lastDoDont.nil? || lastDoDont[:do]
    result += solveMul(mul[:mul])
  end
end
p result