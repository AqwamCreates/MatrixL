local module = {}

local function onBroadcastError(matrix1, matrix2)
	
	local errorMessage = "Unable To Broadcast. \n" .. "Matrix 1 Size: " .. "(" .. #matrix1 .. ", " .. #matrix1[1] .. ") \n" .. "Matrix 2 Size: " .. "(" .. #matrix2[1] .. ", " .. #matrix2[1] .. ") \n"
	
	error(errorMessage)
	
end

local function checkIfCanBroadcast(matrix1, matrix2)
	
	local matrix1Rows = #matrix1
	
	local matrix2Rows = #matrix2
	
	local matrix1Columns = #matrix1[1]
	local matrix2Columns = #matrix2[1]
	
	local isMatrix1Broadcasted
	local isMatrix2Broadcasted
	
	if (matrix1Rows == matrix2Rows) and (matrix1Columns == matrix2Columns) then
		
		isMatrix1Broadcasted = false
		isMatrix2Broadcasted = false
		
	elseif (matrix1Rows == 1) and (matrix1Columns == 1) and (matrix2Rows == 1) and (matrix2Columns == 1) then

		isMatrix1Broadcasted = false
		isMatrix2Broadcasted = false
	
	elseif (matrix2Rows > 1) or (matrix2Columns > 1) then
		
		isMatrix1Broadcasted = true
		isMatrix2Broadcasted = false
		
	elseif (matrix1Rows > 1) or (matrix1Columns > 1) then
		
		isMatrix1Broadcasted = false
		isMatrix2Broadcasted = true
		
	else
		
		onBroadcastError(matrix1, matrix2)
		
	end
	
	return isMatrix1Broadcasted, isMatrix2Broadcasted
	
end

local function broadcastMatrix(matrix, rowSize, columnSize)
	
	local result = {}
	local value = matrix[1][1]
	
	for row = 1, rowSize, 1 do
		
		result[row] = {}
		
		for column = 1, columnSize, 1 do
			
			result[row][column] = value
			
		end
		
	end
	
	return result
	
end

function module:matrixBroadcast(matrix1, matrix2)
	
	local isMatrix1Broadcasted = false
	local isMatrix2Broadcasted = false

	isMatrix1Broadcasted, isMatrix2Broadcasted = checkIfCanBroadcast(matrix1, matrix2)

	if (isMatrix1Broadcasted == true) then

		matrix1 = broadcastMatrix(matrix1, #matrix2, #matrix2[1])

	elseif (isMatrix2Broadcasted == true) then

		matrix2 = broadcastMatrix(matrix2, #matrix1, #matrix1[1])

	end

	return matrix1, matrix2		
	
end

return module
