require 'awesome_print'

def createReport(file_path)
  File.read(file_path).split("\n").map { |line| line.split.map(&:to_i) }
end

def generateSubReports(report)
  (0..report.size).map { |i| report.dup.tap { |e| e.delete_at(i) } }
end

def getDiffs(sub_report)
  sub_report.each_cons(2).map { |a, b| a - b }
end

def isReportSafe(report)
  generateSubReports(report).any? do |sub_report|
    diffs = getDiffs(sub_report)
    diffs.all? { |diff| diff.between?(1, 3) } || diffs.all? { |diff| diff.between?(-3, -1) }
  end
end

reports = createReport("input2.txt")
nbOfSafe = reports.count { |report| isReportSafe(report) }

p nbOfSafe