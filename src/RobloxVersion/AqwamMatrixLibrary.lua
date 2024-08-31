--[[

	--------------------------------------------------------------------

	Aqwam's Matrix Library (MatrixL)

	Version: 1.95

	Author: Aqwam Harish Aiman
	
	Email: aqwam.harish.aiman@gmail.com
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
	
	By using or possesing any copies of this library, you agree to our Terms and Conditions at:
	
	https://aqwamcreates.github.io/MatrixL/TermsAndConditions.html
	
	--------------------------------------------------------------------
	
	DO NOT REMOVE THIS TEXT!
	
	--------------------------------------------------------------------

--]]

local libraryVersion = 1.95

local AqwamMatrixLibrary = {}

local module = {}

local function onBroadcastError(matrix1, matrix2)

	local errorMessage = "Unable To Broadcast. \n" .. "Matrix 1 Size: " .. "(" .. #matrix1 .. ", " .. #matrix1[1] .. ") \n" .. "Matrix 2 Size: " .. "(" .. #matrix2 .. ", " .. #matrix2[1] .. ") \n"

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

	local isMatrix1IsLargerInOneDimension = ((matrix1Rows > 1) and hasSameColumnSize and (matrix2Rows == 1)) or ((matrix1Columns > 1) and hasSameRowSize and (matrix2Columns == 1))

	local isMatrix2IsLargerInOneDimension = ((matrix2Rows > 1) and hasSameColumnSize and (matrix1Rows == 1)) or ((matrix2Columns > 1) and hasSameRowSize and (matrix1Columns == 1))

	local isMatrix1Scalar = (matrix1Rows == 1) and (matrix1Columns == 1)

	local isMatrix2Scalar = (matrix2Rows == 1) and (matrix2Columns == 1)

	local isMatrix1Larger = ((matrix1Rows > matrix2Rows) or (matrix1Columns > matrix2Columns)) and not ((matrix1Rows < matrix2Rows) or (matrix1Columns < matrix2Columns))

	local isMatrix2Larger = ((matrix2Rows > matrix1Rows) or (matrix2Columns > matrix1Columns)) and not ((matrix2Rows < matrix1Rows) or (matrix2Columns < matrix1Columns))

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

function AqwamMatrixLibrary:expand(matrix, targetRowSize, targetColumnSize)

	local result = {}

	local isMatrixRowSizeEqualToOne = (#matrix == 1)

	local isMatrixColumnSizeEqualToOne = (#matrix[1] == 1)

	if (isMatrixRowSizeEqualToOne == true) and (isMatrixColumnSizeEqualToOne == false) then

		for row = 1, targetRowSize, 1 do

			result[row] = {}

			for column = 1, targetColumnSize, 1 do result[row][column] = matrix[1][column] end

		end

	elseif (isMatrixRowSizeEqualToOne == false) and (isMatrixColumnSizeEqualToOne == true) then

		for row = 1, targetRowSize, 1 do

			result[row] = {}

			for column = 1, targetColumnSize, 1 do result[row][column] = matrix[row][1] end

		end

	elseif (isMatrixRowSizeEqualToOne == true) and (isMatrixColumnSizeEqualToOne == true) then

		for row = 1, targetRowSize, 1 do

			result[row] = {}

			for column = 1, targetColumnSize, 1 do result[row][column] = matrix[1][1] end

		end

	end

	return result

end

function AqwamMatrixLibrary:broadcast(matrix1, matrix2)

	local isMatrix1Broadcasted, isMatrix2Broadcasted = checkIfCanBroadcast(matrix1, matrix2)

	if (isMatrix1Broadcasted) then

		matrix1 = AqwamMatrixLibrary:expand(matrix1, #matrix2, #matrix2[1])

	elseif (isMatrix2Broadcasted) then

		matrix2 = AqwamMatrixLibrary:expand(matrix2, #matrix1, #matrix1[1])

	end

	return matrix1, matrix2		

end

local function horizontalConcatenate(matrix1, matrix2)

	local matrix1RowSize = #matrix1
	local matrix2RowSize = #matrix2

	if (matrix1RowSize ~= matrix2RowSize) then error("Incompatible Matrix Dimensions. Matrix 1 Has " .. matrix1RowSize .. " Row(s), Matrix 2 Has " .. matrix2RowSize .. " Row(s).") end

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

local function verticalConcatenate(matrix1, matrix2)

	local matrix1ColumnSize = #matrix1[1]
	local matrix2ColumnSize = #matrix2[1]

	if (matrix1ColumnSize ~= matrix2ColumnSize) then error("Incompatible Matrix Dimensions. Matrix 1 Has " .. matrix1ColumnSize .. " Column(s), Matrix 2 Has " .. matrix2ColumnSize .. " Column(s).") end

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

local function convertToMatrixIfScalar(value)

	local isNotScalar

	isNotScalar = pcall(function()

		local testForScalar = value[1][1]

	end)

	if not isNotScalar then

		return {{value}}

	else

		return value

	end

end

local function onDotProductError(matrix1Column, matrix2Row)

	local errorMessage = "Incompatible Matrix Dimensions: " .. matrix1Column .. " Column(s), " .. matrix2Row .. " Row(s)."

	error(errorMessage)

end

local function checkIfCanDotProduct(matrix1, matrix2)

	local matrix1Column = #matrix1[1]
	local matrix2Row = #matrix2

	if (matrix1Column ~= matrix2Row) then

		onDotProductError(matrix1Column, matrix2Row)

	end

end

local function dotProduct(matrix1, matrix2)

	local result = {}

	local matrix1Row = #matrix1
	local matrix1Column = #matrix1[1]
	local matrix2Column = #matrix2[1]

	local extractedMatrix2Column
	local multipliedRowVector
	local calculatedVectorSum

	checkIfCanDotProduct(matrix1, matrix2)

	for row = 1, matrix1Row, 1 do

		result[row] = {}

		for column = 1, matrix2Column, 1 do

			local sum = 0

			for i = 1, matrix1Column do sum = sum + (matrix1[row][i] * matrix2[i][column]) end

			result[row][column] = sum

		end

	end

	local isScalar = (#result == 1 and #result[1] == 1)

	return (isScalar and result[1][1]) or result

end

local function generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)

	local text1 = "Argument " .. firstMatrixIndex .. " and " .. secondMatrixIndex .. " are incompatible! "

	local text2 = "(" ..  #matrices[firstMatrixIndex] .. ", " .. #matrices[firstMatrixIndex][1] .. ") and " .. "(" ..  #matrices[secondMatrixIndex] .. ", " .. #matrices[secondMatrixIndex][1] .. ")"

	local text = text1 .. text2

	return text

end

local function applyFunctionUsingOneMatrix(functionToApply, matrix)

	local result = {}

	for row = 1, #matrix, 1 do

		result[row] = {}

		for column = 1, #matrix[1], 1 do

			result[row][column] = functionToApply(matrix[row][column])

		end

	end

	return result

end

local function applyFunctionUsingTwoMatrices(functionToApply, matrix1, matrix2)

	if (#matrix1 ~= #matrix2) or (#matrix1[1] ~= #matrix2[1]) then error("Incompatible Dimensions! (" .. #matrix1 .." x " .. #matrix1[1] .. ") and (" .. #matrix2 .. " x " .. #matrix2[1] .. ")") end

	local result = {}

	for row = 1, #matrix1, 1 do

		result[row] = {}

		for column = 1, #matrix1[1], 1 do

			result[row][column] = functionToApply(matrix1[row][column], matrix2[row][column])

		end

	end

	return result

end

local function applyFunctionWhenTheFirstValueIsAScalar(functionToApply, scalar, matrix)

	local result = {}

	for row = 1, #matrix, 1 do

		result[row] = {}

		for column = 1, #matrix[1], 1 do

			result[row][column] = functionToApply(scalar, matrix[row][column])

		end

	end

	return result

end

local function applyFunctionWhenTheSecondValueIsAScalar(functionToApply, matrix, scalar)

	local result = {}

	for row = 1, #matrix, 1 do

		result[row] = {}

		for column = 1, #matrix[1], 1 do

			result[row][column] = functionToApply(matrix[row][column], scalar)

		end

	end

	return result

end

local function applyFunctionUsingMultipleMatrices(functionToApply, ...)

	local matrices = {...}

	local numberOfMatrices = #matrices

	local matrix = matrices[1]

	if (numberOfMatrices == 1) then 

		if (type(matrix) == "table") then

			return applyFunctionUsingOneMatrix(functionToApply, matrix) 

		else

			return functionToApply(matrix)

		end

	end

	for i = 2, numberOfMatrices, 1 do

		local otherMatrix = matrices[i]

		local isFirstValueIsMatrix = (type(matrix) == "table")

		local isSecondValueIsMatrix = (type(otherMatrix) == "table")

		if (isFirstValueIsMatrix) and (isSecondValueIsMatrix) then

			matrix, otherMatrix = AqwamMatrixLibrary:broadcast(matrix, otherMatrix)

			matrix = applyFunctionUsingTwoMatrices(functionToApply, matrix, otherMatrix)

		elseif (not isFirstValueIsMatrix) and (isSecondValueIsMatrix) then

			matrix = applyFunctionWhenTheFirstValueIsAScalar(functionToApply, matrix, otherMatrix)

		elseif (isFirstValueIsMatrix) and (not isSecondValueIsMatrix) then

			matrix = applyFunctionWhenTheSecondValueIsAScalar(functionToApply, matrix, otherMatrix)

		else

			matrix = functionToApply(matrix, otherMatrix)

		end

	end

	return matrix

end

function AqwamMatrixLibrary:add(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a + b end, ...)

end

function AqwamMatrixLibrary:subtract(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a - b end, ...)

end

function AqwamMatrixLibrary:multiply(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a * b end, ...)

end

function AqwamMatrixLibrary:divide(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a / b end, ...)

end

function AqwamMatrixLibrary:logarithm(...)

	return applyFunctionUsingMultipleMatrices(math.log, ...)

end

function AqwamMatrixLibrary:power(...)

	return applyFunctionUsingMultipleMatrices(math.pow, ...)

end

function AqwamMatrixLibrary:areValuesEqual(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a == b end, ...)

end

function AqwamMatrixLibrary:areValuesGreater(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a > b end, ...)

end

function AqwamMatrixLibrary:areValuesGreaterOrEqual(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a >= b end, ...)

end

function AqwamMatrixLibrary:areValuesLesser(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a < b end, ...)

end

function AqwamMatrixLibrary:areValuesLesserOrEqual(...)

	return applyFunctionUsingMultipleMatrices(function(a, b) return a <= b end, ...)

end

function AqwamMatrixLibrary:areMatricesEqual(...)

	local resultMatrix = applyFunctionUsingMultipleMatrices(function(a, b) return a == b end, ...)

	for row = 1, #resultMatrix, 1 do

		for column = 1, #resultMatrix[1], 1 do

			if (resultMatrix[row][column] == false) then return false end

		end

	end

	return true

end

function AqwamMatrixLibrary:dotProduct(...)

	local matrices = {...}

	local numberOfMatrices = #matrices

	if (numberOfMatrices == 1) then warn("Only one argument!") end

	local result = matrices[1]

	result = convertToMatrixIfScalar(result)

	for i = 2, numberOfMatrices, 1 do

		result = convertToMatrixIfScalar(result)

		result = dotProduct(result, matrices[i])

	end

	return result

end

function AqwamMatrixLibrary:sum(matrix)

	local result = 0

	local matrixRows = #matrix
	local matrixColumns = #matrix[1]

	for row = 1, matrixRows, 1 do

		for column = 1, matrixColumns, 1 do

			result += matrix[row][column]

		end

	end

	return result

end

function AqwamMatrixLibrary:createIdentityMatrix(numberOfRows, numberOfColumns)

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			if (row == column) then

				result[row][column] = 1

			else

				result[row][column] = 0

			end

		end

	end

	return result

end

function AqwamMatrixLibrary:createMatrix(numberOfRows, numberOfColumns, allValues)

	allValues = allValues or 0

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = allValues

		end	

	end

	return result

end

function AqwamMatrixLibrary:createRandomMatrix(numberOfRows, numberOfColumns, minimumValue, maximumValue)

	if (minimumValue == nil) and (maximumValue == nil) then

		minimumValue = -100000

		maximumValue = 100000

	elseif (minimumValue == nil) then

		minimumValue = 0

	elseif (maximumValue == nil) then

		maximumValue = 0

	end

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = Random.new():NextInteger(minimumValue, maximumValue)

		end	

	end

	return result

end

function AqwamMatrixLibrary:createRandomNormalMatrix(numberOfRows, numberOfColumns, mean, standardDeviation)

	local result = {}

	local random = Random.new()

	mean = mean or 0

	standardDeviation = standardDeviation or 1

	for row = 1, numberOfRows do

		result[row] = {}

		for column = 1, numberOfColumns do

			local randomNumber1 = random:NextNumber()

			local randomNumber2 = random:NextNumber()

			local zScore = math.sqrt(-2 * math.log(randomNumber1)) * math.cos(2 * math.pi * randomNumber2)

			result[row][column] = (zScore * standardDeviation) + mean

		end
	end

	return result

end

function AqwamMatrixLibrary:createRandomUniformMatrix(numberOfRows, numberOfColumns)

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = Random.new():NextNumber()

		end	

	end

	return result

end

function AqwamMatrixLibrary:getDimensionSizeArray(...)

	local matrixSizeArray = {}

	for i, matrix in ipairs({...}) do

		local numberOfRows = #matrix

		local numberOfColumns = #matrix[1]

		local dimensionSizeArray = {numberOfRows, numberOfColumns}

		table.insert(matrixSizeArray, dimensionSizeArray)

	end

	return table.unpack(matrixSizeArray)

end


function AqwamMatrixLibrary:transpose(matrix)

	local currentRowVector

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamMatrixLibrary:createMatrix(numberOfColumns, numberOfRows)

	for row = 1, numberOfRows, 1 do

		currentRowVector = matrix[row]

		for column = 1, #currentRowVector, 1 do

			result[column][row] = currentRowVector[column]

		end

	end

	return result

end

function AqwamMatrixLibrary:verticalSum(matrix)

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamMatrixLibrary:createMatrix(1, numberOfColumns)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[1][column] += matrix[row][column]

		end	

	end

	return result

end

function AqwamMatrixLibrary:horizontalSum(matrix)

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamMatrixLibrary:createMatrix(numberOfRows, 1)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[row][1] += matrix[row][column]

		end	

	end

	return result

end

function AqwamMatrixLibrary:mean(matrix)

	local sum = 0

	local numberOfElements = #matrix * #matrix[1]

	local sum = AqwamMatrixLibrary:sum(matrix)

	local mean = sum/numberOfElements

	return mean

end

function AqwamMatrixLibrary:verticalMean(matrix)

	local numberOfRows = #matrix

	local verticalSum = AqwamMatrixLibrary:verticalSum(matrix)

	local result = AqwamMatrixLibrary:divide(verticalSum, numberOfRows) 

	return result

end

function AqwamMatrixLibrary:horizontalMean(matrix)

	local numberOfColumns = #matrix[1]

	local horizontalSum = AqwamMatrixLibrary:horizontalSum(matrix)

	local result = AqwamMatrixLibrary:divide(horizontalSum, numberOfColumns)

	return result

end

function AqwamMatrixLibrary:standardDeviation(matrix)

	local mean = AqwamMatrixLibrary:mean(matrix)

	local numberOfElements = #matrix * #matrix[1]

	local sum = 0

	local squaredSum

	local standardDeviation

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			sum += matrix[row][column] - mean

		end

	end

	squaredSum = sum^2

	standardDeviation = math.sqrt(squaredSum/numberOfElements)

	return standardDeviation, mean

end

function AqwamMatrixLibrary:verticalStandardDeviation(matrix)

	local verticalMean = AqwamMatrixLibrary:verticalMean(matrix)

	local matrixSubtractedByMean = AqwamMatrixLibrary:subtract(matrix, verticalMean)

	local squaredMatrixSubtractedByMean = AqwamMatrixLibrary:power(matrixSubtractedByMean, 2)

	local summedSquaredMatrixSubtractedByMean = AqwamMatrixLibrary:verticalSum(squaredMatrixSubtractedByMean, 2)

	local divisor =  #matrix - 1

	local dividedMatrix = AqwamMatrixLibrary:divide(summedSquaredMatrixSubtractedByMean, divisor)

	local squareRootMatrix = AqwamMatrixLibrary:power(dividedMatrix, 0.5)

	return squareRootMatrix, verticalMean

end

function AqwamMatrixLibrary:horizontalStandardDeviation(matrix)

	local horizontalMean = AqwamMatrixLibrary:horizontalMean(matrix)

	local matrixSubtractedByMean = AqwamMatrixLibrary:subtract(matrix, horizontalMean)

	local squaredMatrixSubtractedByMean = AqwamMatrixLibrary:power(matrixSubtractedByMean, 2)

	local summedSquaredMatrixSubtractedByMean = AqwamMatrixLibrary:horizontalSum(squaredMatrixSubtractedByMean, 2)

	local divisor =  #matrix[1] - 1

	local dividedMatrix = AqwamMatrixLibrary:divide(summedSquaredMatrixSubtractedByMean, divisor)

	local squareRootMatrix = AqwamMatrixLibrary:power(dividedMatrix, 0.5)

	return squareRootMatrix, horizontalMean

end

function AqwamMatrixLibrary:generateMatrixString(matrix)
	
	if matrix == nil then return "" end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local columnWidths = {}

	-- Calculate maximum width for each column
	for column = 1, numberOfColumns do

		local maxWidth = 0

		for row = 1, numberOfRows do

			local cellWidth = string.len(tostring(matrix[row][column]))

			if (cellWidth > maxWidth) then

				maxWidth = cellWidth

			end

		end

		columnWidths[column] = maxWidth

	end

	local text = ""

	for row = 1, numberOfRows do

		text = text .. "{"

		for column = 1, numberOfColumns do

			local cellValue = matrix[row][column]

			local cellText = tostring(cellValue)

			local cellWidth = string.len(cellText)

			local padding = columnWidths[column] - cellWidth + 1

			text = text .. string.rep(" ", padding) .. cellText
		end

		text = text .. " }\n"
	end

	return text
	
end

function AqwamMatrixLibrary:printMatrix(...)

	local text = "\n\n"

	local generatedText

	local matrices = {...}

	for matrixNumber = 1, #matrices, 1 do

		generatedText = AqwamMatrixLibrary:generateMatrixString(matrices[matrixNumber])

		text = text .. generatedText

		text = text .. "\n"

	end

	print(text)

end

function AqwamMatrixLibrary:generateMatrixWithCommaString(matrix)
	
	if matrix == nil then return "" end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local columnWidths = {}

	-- Calculate maximum width for each column
	for column = 1, numberOfColumns do

		local maxWidth = 0

		for row = 1, numberOfRows do

			local cellWidth = string.len(tostring(matrix[row][column]))

			if (column < numberOfColumns) then

				cellWidth += 1

			end

			if (cellWidth > maxWidth) then

				maxWidth = cellWidth

			end

		end

		columnWidths[column] = maxWidth

	end

	local text = ""

	for row = 1, numberOfRows do

		text = text .. "{"

		for column = 1, numberOfColumns do

			local cellValue = matrix[row][column]

			local cellText = tostring(cellValue) 

			local cellWidth = string.len(cellText)

			local padding = columnWidths[column] - cellWidth + 1

			text = text .. string.rep(" ", padding) .. cellText

			if (column < numberOfColumns) then

				text = text .. ","

			end

		end

		text = text .. " }\n"
	end

	return text
	
end

function AqwamMatrixLibrary:printMatrixWithComma(...)

	local text = "\n\n"

	local generatedText

	local matrices = {...}

	for matrixNumber = 1, #matrices, 1 do

		generatedText = AqwamMatrixLibrary:generateMatrixWithCommaString(matrices[matrixNumber])

		text = text .. generatedText

		text = text .. "\n"

	end

	print(text)

end

function AqwamMatrixLibrary:generatePortableMatrixString(matrix)

	if matrix == nil then return "" end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local columnWidths = {}

	-- Calculate maximum width for each column
	for column = 1, numberOfColumns do

		local maxWidth = 0

		for row = 1, numberOfRows do

			local cellWidth = string.len(tostring(matrix[row][column]))

			if (column < numberOfColumns) then

				cellWidth += 1

			end

			if (cellWidth > maxWidth) then

				maxWidth = cellWidth

			end

		end

		columnWidths[column] = maxWidth

	end

	local text = "{\n"

	for row = 1, numberOfRows do

		text = text .. "\t{"

		for column = 1, numberOfColumns do

			local cellValue = matrix[row][column]

			local cellText = tostring(cellValue) 

			local cellWidth = string.len(cellText)

			local padding = columnWidths[column] - cellWidth + 1

			text = text .. string.rep(" ", padding) .. cellText

			if (column < numberOfColumns) then

				text = text .. ","

			end

		end

		text = text .. " },\n"

	end

	text = text .. "}\n"

	return text

end

function AqwamMatrixLibrary:printPortableMatrix(...)

	local text = "\n\n"

	local generatedText

	local matrices = {...}

	for matrixNumber = 1, #matrices, 1 do

		generatedText = AqwamMatrixLibrary:generatePortableMatrixString(matrices[matrixNumber])

		text = text .. generatedText

		text = text .. "\n"

	end

	print(text)

end

function AqwamMatrixLibrary:horizontalConcatenate(...)

	local matrices = {...}

	local lastMatrixIndex = #matrices
	local secondLastMatrixIndex = lastMatrixIndex - 1 

	local result = matrices[1]

	for i = 2, #matrices, 1 do

		local success = pcall(function()

			result = horizontalConcatenate(result, matrices[i])

		end)

		if (not success) then

			local text = generateArgumentErrorString(matrices, i - 1, i)

			error(text)

		end

	end

	return result

end

function AqwamMatrixLibrary:verticalConcatenate(...)

	local matrices = {...}

	local lastMatrixIndex = #matrices
	local secondLastMatrixIndex = lastMatrixIndex - 1 

	local result = matrices[1]

	for i = 2, #matrices, 1 do

		local success = pcall(function()

			result = verticalConcatenate(result, matrices[i])

		end)

		if (not success) then

			local text = generateArgumentErrorString(matrices, i - 1, i)

			error(text)

		end

	end

	return result

end


function AqwamMatrixLibrary:applyFunction(functionToApply, ...)

	local matricesValues

	local matrices = {...}
	local matrix = matrices[1]

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamMatrixLibrary:createMatrix(numberOfRows, numberOfColumns)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			matricesValues = {}

			for matrixArgument = 1, #matrices, 1  do

				table.insert(matricesValues, matrices[matrixArgument][row][column])

			end 

			result[row][column] = functionToApply(table.unpack(matricesValues))

		end	

	end

	return result

end

function AqwamMatrixLibrary:findMaximumValue(matrix)

	local matrixIndex

	local currentValue

	local maximumValue = -math.huge

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			currentValue = matrix[row][column]

			if (currentValue > maximumValue) then

				maximumValue = currentValue

				matrixIndex = {row, column}

			end

		end

	end

	return maximumValue, matrixIndex

end

function AqwamMatrixLibrary:findMinimumValue(matrix)

	local matrixIndex

	local currentValue

	local minimumValue = math.huge

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			currentValue = matrix[row][column]

			if (currentValue < minimumValue) then

				minimumValue = currentValue

				matrixIndex = {row, column}

			end

		end

	end

	return minimumValue, matrixIndex

end

function AqwamMatrixLibrary:zScoreNormalization(matrix)

	local standardDeviation, mean = AqwamMatrixLibrary:standardDeviation(matrix)

	local result = AqwamMatrixLibrary:subtract(matrix, mean)

	result = AqwamMatrixLibrary:divide(result, standardDeviation)

	return result, standardDeviation, mean

end

function AqwamMatrixLibrary:verticalZScoreNormalization(matrix)

	local verticalStandardDeviaton, verticalMean = AqwamMatrixLibrary:verticalStandardDeviation(matrix)

	local result = AqwamMatrixLibrary:subtract(matrix, verticalMean)

	result = AqwamMatrixLibrary:divide(result, verticalStandardDeviaton)

	return result, verticalStandardDeviaton, verticalMean

end

function AqwamMatrixLibrary:horizontalZScoreNormalization(matrix)

	local horizontalStandardDeviation, horizontalMean = AqwamMatrixLibrary:horizontalStandardDeviation(matrix)

	local result = AqwamMatrixLibrary:subtract(matrix, horizontalMean)

	result = AqwamMatrixLibrary:divide(result, horizontalStandardDeviation)

	return result, horizontalStandardDeviation, horizontalMean

end

function AqwamMatrixLibrary:extractRows(matrix, startingRowIndex, endingRowIndex)

	if (endingRowIndex == nil) then endingRowIndex = #matrix end

	if (startingRowIndex <= 0) then error("The starting row index must be greater than 0!") end 

	if (endingRowIndex <= 0) then error("The ending row index must be greater than 0!") end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local result = {}

	for row = startingRowIndex, endingRowIndex do

		table.insert(result, matrix[row])

	end

	return result

end

function AqwamMatrixLibrary:extractColumns(matrix, startingColumnIndex, endingColumnIndex)

	if (endingColumnIndex == nil) then endingColumnIndex = #matrix end

	if (startingColumnIndex <= 0) then error("The starting column index must be greater than 0!") end 

	if (endingColumnIndex <= 0) then error("The ending column index must be greater than 0!") end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local result = {}
	
	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = startingColumnIndex, endingColumnIndex do 

			table.insert(result[row], matrix[row][column])

		end

	end

	return result

end

function AqwamMatrixLibrary:copy(matrix)

	if (type(matrix) ~= "table") then return matrix end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local result = AqwamMatrixLibrary:createMatrix(numberOfRows, numberOfColumns)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[row][column] = matrix[row][column]

		end

	end

	return result

end

function AqwamMatrixLibrary:minor(matrix, row, column)

	local dimensionSize = #matrix

	local minor = {}

	for i = 1, dimensionSize - 1 do

		minor[i] = {}

		for j = 1, dimensionSize - 1 do

			local mRow = (i < row and i) or (i + 1)

			local mColumn = (j < column and j) or (j + 1)

			minor[i][j] = matrix[mRow][mColumn]

		end

	end

	return minor

end

function  AqwamMatrixLibrary:cofactor(matrix, row, column)

	local minor =  AqwamMatrixLibrary:minor(matrix, row, column)

	local sign = (((row + column) % 2 == 0) and 1) or -1

	return sign * AqwamMatrixLibrary:determinant(minor)

end

function AqwamMatrixLibrary:determinant(matrix)

	local dimensionSize = #matrix

	if (dimensionSize == 1) then

		return matrix[1][1]

	elseif (dimensionSize == 2) then

		return matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1]

	else

		local determinant = 0

		for i = 1, dimensionSize do

			local cofactor =  AqwamMatrixLibrary:cofactor(matrix, 1, i)

			determinant = determinant + matrix[1][i] * cofactor

		end

		return determinant

	end

end

function AqwamMatrixLibrary:inverse(matrix)

	if (#matrix ~= #matrix[1]) then return nil end

	local dimensionSize = #matrix

	local determinant = AqwamMatrixLibrary:determinant(matrix)

	if (determinant == 0) then

		return nil -- matrix is not invertible

	elseif (dimensionSize == 1) then

		return {{1 / determinant}}

	else

		local adjugate = {}

		for i = 1, dimensionSize do

			adjugate[i] = {}

			for j = 1, dimensionSize do

				local sign = ((i + j) % 2 == 0) and 1 or -1

				local cof = AqwamMatrixLibrary:cofactor(matrix, i, j)

				adjugate[i][j] = sign * cof

			end

		end

		local inverse = AqwamMatrixLibrary:transpose(adjugate)

		for i = 1, dimensionSize do

			for j = 1, dimensionSize do

				inverse[i][j] = inverse[i][j] / determinant

			end

		end

		return inverse

	end

end

function AqwamMatrixLibrary:isMatrix(matrix)

	local matrixCheck

	local notIndexNumberCheck

	local itIsAMatrix

	matrixCheck = pcall(function()

		local test = matrix[1][1]

	end)

	notIndexNumberCheck = pcall(function()

		local test = matrix[1][1][1]

	end)

	itIsAMatrix = (matrixCheck) and (not notIndexNumberCheck)

	return itIsAMatrix 

end

function AqwamMatrixLibrary:findNanValue(matrix)

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1] do

			local value = matrix[row][column]

			if (value ~= value) then return {row, column} end

		end

	end

	return nil

end

function AqwamMatrixLibrary:findValue(matrix, valueToFind)

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1] do 

			if (matrix[row][column] == valueToFind) then return {row, column} end

		end

	end

	return nil

end

function AqwamMatrixLibrary:setValue(matrix, value, rowIndex, columnIndex)

	local dimensionSizeArray = AqwamMatrixLibrary:getDimensionSizeArray(matrix)

	if (rowIndex < 1) or (rowIndex > dimensionSizeArray[1]) or (columnIndex < 1) or (columnIndex > dimensionSizeArray[2]) then error("Attempting to set a value that is out of bounds.") end

	matrix[rowIndex][columnIndex] = value

end

function AqwamMatrixLibrary:getValue(matrix, rowIndex, columnIndex)

	local dimensionSizeArray = AqwamMatrixLibrary:getDimensionSizeArray(matrix)

	if (rowIndex < 1) or (rowIndex > dimensionSizeArray[1]) or (columnIndex < 1) or (columnIndex > dimensionSizeArray[2]) then error("Attempting to get a value that is out of bounds.") end

	return matrix[rowIndex][columnIndex]

end

function AqwamMatrixLibrary:getVersion()

	return libraryVersion

end

return AqwamMatrixLibrary
