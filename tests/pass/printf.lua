os.exit((function(args)
	local a = 42
	local b = 3.14
	print(string.format("Valor: %d e %f", a, b))
	print("fim")
	return 0
end)(arg))
