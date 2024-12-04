def createReport(file_path)
  File.read(file_path).split("\n").map { |line| line.split("") }
end

#lines[y][x]
lines = createReport("input4.txt")
numberOfXMAS = 0

lines.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if y > 0 && x > 0 && y < lines.length - 1 && x < line.length - 1
      if char == "A"
        diags = []
        diags.push(lines[y - 1][x - 1])
        diags.push(lines[y - 1][x + 1])
        diags.push(lines[y + 1][x - 1])
        diags.push(lines[y + 1][x + 1])
        if diags.any? { |diag| diag == "X" || diag == "A" }
          next
        end
        if diags[0] != diags[3]
          if diags[1] != diags[2]
            numberOfXMAS += 1 
          end
        end
      end
    end
  end
end
p numberOfXMAS
