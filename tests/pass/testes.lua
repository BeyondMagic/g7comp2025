local function sum(a, b)
  return a + b
end

os.exit((function(args)
  local r = sum(1, 3)
  print(r)
  return 0
end)(arg))
