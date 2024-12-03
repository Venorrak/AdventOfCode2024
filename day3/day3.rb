require 'awesome_print'

muls = []

def createReport(file_path)
  File.read(file_path).split("\n").join("")
end

def getMuls(input)
  regex = /mul\(\d{1,3},\d{1,3}\)/
  muls = input.scan(regex)
  mulsPos = input.enum_for(:scan, regex).map { Regexp.last_match.begin(0) }
  return muls
end

def solveMul(mul)
  mul = mul.delete_prefix("mul(")
  mul = mul.delete_suffix(")")
  mul = mul.split(",")
  mul[0].to_i * mul[1].to_i
end

input = createReport("input3.txt")
muls = getMuls(input)
total = 0
muls.each do |mul|
  total += solveMul(mul)
end
p total