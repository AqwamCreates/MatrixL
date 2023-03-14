local module = {}

function module:horizontalConcatenate(matrix1, matrix2)
	
	if (#matrix1 ~= #matrix2) then error() end
	
	local horizontalMiddleIndex = #matrix1[1]

	local result = {}

	for row = 1, #matrix1, 1 do

		result[row] = {}

		for column = 1, #matrix1[1], 1 do

			result[row][column] = matrix1[row][column]

		end	

	end

	for row = 1, #matrix2, 1 do

		for column = 1, #matrix2[1], 1 do

			result[row][horizontalMiddleIndex + column] = matrix2[row][column]
		
		end
		
	end
	
	return result

end

function module:verticalConcatenate(matrix1, matrix2)
	
	if (#matrix1[1] ~= #matrix2[1]) then error() end
	
	local verticalMiddleIndex = #matrix1

	local result = {}

	for row = 1, #matrix1, 1 do

		result[row] = {}

		for column = 1, #matrix1[1], 1 do

			result[row][column] = matrix1[row][column]

		end	

	end
	
	for row = 1, #matrix2, 1 do

		result[verticalMiddleIndex + row] = {}

		for column = 1, #matrix2[1], 1 do

			result[verticalMiddleIndex + row][column] = matrix2[row][column]

		end	

	end
	
	return result

end

return module
