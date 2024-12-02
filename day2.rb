require 'awesome_print'

def createReport(file_path)
  reports = []
  File.open(file_path).each do |line|
    levels = line.split(" ")
    levels.map!(&:to_i)
    reports.push(levels)
  end
  reports
end

def isReportAscending(report)
  (report.count - 1).times do |i|
    if report[i] >= report[i+1]
      return false
    end
  end
  return true
end

def isReportDescending(report)
  (report.count - 1).times do |i|
    if report[i] <= report[i+1]
      return false
    end
  end
  return true
end

def tryRemovingForAscending(report)
  new_report = report.dup
  (report.count - 1).times do |i|
    if new_report[i] >= new_report[i+1]
      new_report.delete_at(i + 1)
      return new_report
    end
  end
  return new_report
end

def tryRemovingForDescending(report)
  new_report = report.dup
  (new_report.count - 1).times do |i|
    if new_report[i] <= new_report[i+1]
      new_report.delete_at(i + 1)
      return new_report
    end
  end
  return new_report
end

def isReportDiffSafe(report)
  (report.count - 1).times do |i|
    diffWithNext = report[i] - report[i+1]
    diffWithNext = diffWithNext.abs
    if diffWithNext > 3 || diffWithNext < 1
      return false
    end
  end
  return true
end

def tryRemovingForDiffSafe(report)
  new_report = report.dup
  (new_report.count - 1).times do |i|
    diffWithNext = new_report[i] - new_report[i+1]
    diffWithNext = diffWithNext.abs
    if diffWithNext > 3 || diffWithNext < 1
      new_report.delete_at(i + 1)
      return new_report
    end
  end
  return new_report
end

def isReportSafe(report)
  cantAsc = false
  if !isReportAscending(tryRemovingForAscending(report))
    cantAsc = true
  end

  cantDesc = false
  if !isReportDescending(tryRemovingForDescending(report))
    cantDesc = true
  end

  if cantAsc && cantDesc
    return false
  else
    orderedReport = nil
    if cantAsc
      orderedReport = tryRemovingForDescending(report)
    elsif cantDesc
      orderedReport = tryRemovingForAscending(report)
    else
      p "wtf"
      return false
    end

    if orderedReport != report
      return isReportDiffSafe(orderedReport)
    else
      if !isReportDiffSafe(tryRemovingForDiffSafe(orderedReport))
        return false
      end
    end
  end
  return true
end

reports = createReport("input2.txt")
nbOfSafe = 0

reports.each do |report|
  if isReportSafe(report)
    nbOfSafe += 1
  end
end

p nbOfSafe
