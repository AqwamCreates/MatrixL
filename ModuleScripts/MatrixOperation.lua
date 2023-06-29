local module = {}

local matrixOperationFunction = {
	
	['+'] = function (x, y) return (x + y) end,
	['-'] = function (x, y) return (x - y) end,
	['*'] = function (x, y) return (x * y) end,
	['/'] = function (x, y) return (x / y) end,
	['%'] = function (x, y) return (x % y) end,
	
	['=='] = function (x, y) return (x == y) end,
	['>'] = function (x, y) return (x > y) end,
	['<'] = function (x, y) return (x < y) end,
	['>='] = function (x, y) return (x >= y) end,
	['<='] = function (x, y) return (x <= y) end,
	
	['log'] = function (x, y) return (math.log(x, y)) end,
	
	['exp'] = function (x, y) return (math.exp(x, y)) end,
	['e'] = function (x, y) return (math.exp(x, y)) end,
	['exponent'] = function (x, y) return (math.exp(x, y)) end,
	
	['^'] = function (x, y) return (math.pow(x, y)) end,
	['power'] = function (x, y) return (math.pow(x, y)) end,
	
}

function module:matrixOperation(operation, matrix1, matrix2)
	
	if (#matrix1 ~= #matrix2) or (#matrix1[1] ~= #matrix2[1]) then error("Incompatible Dimensions! (" .. #matrix1 .." x " .. #matrix1[1] .. ") and (" .. #matrix2 .. " x " .. #matrix2[1] .. ")") end
	
	local maxRow = math.max(#matrix1, #matrix2)
	local maxColumn = math.max(#matrix1[1], #matrix2[1])
	
	local result = {}
	
	for row = 1, maxRow, 1 do
		
		result[row] = {}

		for column = 1, maxColumn, 1 do
				
			result[row][column] = matrixOperationFunction[operation]( matrix1[row][column] , matrix2[row][column] )
				
		end
			
		
	end
	
	return result
	
end

return module
