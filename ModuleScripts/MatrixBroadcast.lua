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
	
	local hasSameRowSize = (matrix1Rows == matrix2Rows)
	
	local hasSameColumnSize = (matrix1Columns == matrix2Columns)
	
	local hasSameDimension = hasSameRowSize and hasSameColumnSize
	
	local isMatrix1IsLargerInOneDimension = ((matrix1Rows > 1) and hasSameColumnSize) or ((matrix1Columns > 1) and hasSameRowSize)
	
	local isMatrix2IsLargerInOneDimension = ((matrix2Rows > 1) and hasSameColumnSize) or ((matrix2Columns > 1) and hasSameRowSize)
	
	local isMatrix1Scalar = (matrix1Rows == 1) and (matrix1Columns == 1)
	
	local isMatrix2Scalar = (matrix2Rows == 1) and (matrix2Columns == 1)
	
	local isMatrix1Larger = (matrix1Rows > matrix2Rows) and (matrix1Columns > matrix2Columns)
	
	local isMatrix2Larger = (matrix2Rows > matrix1Rows) and (matrix2Columns > matrix1Columns)
	
	if (hasSameDimension) then
		
		isMatrix1Broadcasted = false
		isMatrix2Broadcasted = false
	
	elseif (isMatrix2IsLargerInOneDimension) or (isMatrix2Larger and isMatrix1Scalar) then
		
		isMatrix1Broadcasted = true
		isMatrix2Broadcasted = false
		
	elseif (isMatrix1IsLargerInOneDimension) or (isMatrix1Larger and isMatrix2Scalar) then
		
		isMatrix1Broadcasted = false
		isMatrix2Broadcasted = true
		
	else
		
		onBroadcastError(matrix1, matrix2)
		
	end
	
	return isMatrix1Broadcasted, isMatrix2Broadcasted
	
end

local function broadcastMatrix(matrix, rowSize, columnSize)
	
	local result = {}

	local isMatrixSmallerThanRowSize = (#matrix < rowSize)

	local isMatrixSmallerThanColumnSize = (#matrix[1] < columnSize)
	
	if (isMatrixSmallerThanRowSize == true) and (isMatrixSmallerThanColumnSize == false) then

		for row = 1, rowSize, 1 do

			result[row] = {}

			for column = 1, columnSize, 1 do result[row][column] = matrix[1][column] end

		end

	elseif (isMatrixSmallerThanRowSize == false) and (isMatrixSmallerThanColumnSize == true) then

		for row = 1, rowSize, 1 do

			result[row] = {}

			for column = 1, columnSize, 1 do result[row][column] = matrix[row][1] end

		end

	elseif (isMatrixSmallerThanRowSize == true) and (isMatrixSmallerThanColumnSize == true) then

		for row = 1, rowSize, 1 do

			result[row] = {}

			for column = 1, columnSize, 1 do result[row][column] = matrix[1][1] end

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


