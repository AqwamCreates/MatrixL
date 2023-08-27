--[[

	--------------------------------------------------------------------

	Version 1.91

	Aqwam's Roblox Matrix Library (AR-MatrixL)

	Author: Aqwam Harish Aiman
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
	
	DO NOT SELL, RENT, DISTRIBUTE THIS LIBRARY
	
	DO NOT SELL, RENT, DISTRIBUTE MODIFIED VERSION OF THIS LIBRARY
	
	DO NOT CLAIM OWNERSHIP OF THIS LIBRARY
	
	GIVE CREDIT AND SOURCE WHEN USING THIS LIBRARY IF YOUR USAGE FALLS UNDER ONE OF THESE CATEGORIES:
	
		- USED AS A VIDEO OR ARTICLE CONTENT
		- USED AS COMMERCIAL OR PUBLIC USE 
	
	--------------------------------------------------------------------
	
	By using or possesing any copies of this library, you agree to our Terms and Conditions at:
	
	https://aqwamcreates.github.io/MatrixL/TermsAndConditions.html
	
	--------------------------------------------------------------------

--]]


local libraryVersion = 1.9

local MatrixOperation = require(script.MatrixOperation)
local MatrixBroadcast = require(script.MatrixBroadcast)
local MatrixDotProduct = require(script.MatrixDotProduct)
local MatrixConcatenate = require(script.MatrixConcatenate)

local AqwamRobloxMatrixLibrary = {}

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

local function generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)

	local text1 = "Argument " .. firstMatrixIndex .. " and " .. secondMatrixIndex .. " are incompatible! "

	local text2 = "(" ..  #matrices[firstMatrixIndex] .. ", " .. #matrices[firstMatrixIndex][1] .. ") and " .. "(" ..  #matrices[secondMatrixIndex] .. ", " .. #matrices[secondMatrixIndex][1] .. ")"

	local text = text1 .. text2

	return text

end

local function broadcastAndCalculate(operation, ...)

	local matrices = {...}

	local numberOfMatrices = #matrices

	local firstMatrix = matrices[1]

	local secondMatrix

	local result = AqwamRobloxMatrixLibrary:copy(firstMatrix)

	local result = convertToMatrixIfScalar(result)

	for i = 2, numberOfMatrices, 1 do

		local success = pcall(function()

			local secondMatrix = convertToMatrixIfScalar(matrices[i])

			result, secondMatrix = MatrixBroadcast:matrixBroadcast(result, secondMatrix)

			result = MatrixOperation:matrixOperation(operation, result, secondMatrix)

		end)

		if not success then

			local text = generateArgumentErrorString(matrices, (i - 1), i)

			error(text)

		end

	end

	return result

end

function AqwamRobloxMatrixLibrary:add(...)

	return broadcastAndCalculate('+', ...)

end

function AqwamRobloxMatrixLibrary:subtract(...)

	return broadcastAndCalculate('-', ...)

end

function AqwamRobloxMatrixLibrary:multiply(...)

	return broadcastAndCalculate('*', ...)

end

function AqwamRobloxMatrixLibrary:divide(...)

	return broadcastAndCalculate('/', ...)

end

function AqwamRobloxMatrixLibrary:logarithm(...)

	return broadcastAndCalculate('log', ...)

end

function AqwamRobloxMatrixLibrary:exp(...)

	return broadcastAndCalculate('exp', ...)

end

function AqwamRobloxMatrixLibrary:power(...)

	return broadcastAndCalculate('power', ...)

end

function AqwamRobloxMatrixLibrary:areValuesEqual(...)

	return broadcastAndCalculate('==', ...)

end

function AqwamRobloxMatrixLibrary:areValuesGreater(...)

	return broadcastAndCalculate('>', ...)

end

function AqwamRobloxMatrixLibrary:areValuesGreaterOrEqual(...)

	return broadcastAndCalculate('>=', ...)

end

function AqwamRobloxMatrixLibrary:areValuesLesser(...)

	return broadcastAndCalculate('<', ...)

end

function AqwamRobloxMatrixLibrary:areValuesLesserOrEqual(...)

	return broadcastAndCalculate('<=', ...)

end

function AqwamRobloxMatrixLibrary:areMatricesEqual(...)

	local resultMatrix = broadcastAndCalculate('==', ...)

	for row = 1, #resultMatrix, 1 do

		for column = 1, #resultMatrix[1], 1 do

			if (resultMatrix[row][column] == false) then return false end

		end

	end

	return true

end

function AqwamRobloxMatrixLibrary:dotProduct(...)

	local matrices = {...}

	local lastMatrixIndex = #matrices
	local secondLastMatrixIndex = lastMatrixIndex - 1 

	local result

	local success = pcall(function()

		result = MatrixDotProduct:dotProduct(matrices[secondLastMatrixIndex], matrices[lastMatrixIndex])

	end)

	if (not success) then

		local text = generateArgumentErrorString(matrices, secondLastMatrixIndex, lastMatrixIndex)

		error(text)

	end

	if (secondLastMatrixIndex > 1) then

		return AqwamRobloxMatrixLibrary:dotProduct(select(secondLastMatrixIndex - 1, ...), result)

	else

		return result

	end

end

function AqwamRobloxMatrixLibrary:sum(matrix)

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

function AqwamRobloxMatrixLibrary:createIdentityMatrix(numberOfRowsAndColumns)

	local result = {}

	for row = 1, numberOfRowsAndColumns, 1 do

		result[row] = {}

		for column = 1, numberOfRowsAndColumns, 1 do

			if (row == column) then

				result[row][column] = 1

			else

				result[row][column] = 0

			end

		end

	end

	return result

end

function AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, numberOfColumns, allNumberValues)

	allNumberValues = allNumberValues or 0

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = allNumberValues

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:createRandomMatrix(numberOfRows, numberOfColumns, minimumValue, maximumValue)

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

function AqwamRobloxMatrixLibrary:createRandomNormalMatrix(numberOfRows, numberOfColumns)

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = Random.new():NextNumber()

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:getSize(matrix)

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	return {numberOfRows, numberOfColumns}

end


function AqwamRobloxMatrixLibrary:transpose(matrix)

	local currentRowVector

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfColumns, numberOfRows)

	for row = 1, numberOfRows, 1 do

		currentRowVector = matrix[row]

		for column = 1, #currentRowVector, 1 do

			result[column][row] = currentRowVector[column]

		end

	end

	return result

end

function AqwamRobloxMatrixLibrary:verticalSum(matrix)

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(1, numberOfColumns)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[1][column] += matrix[row][column]

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:horizontalSum(matrix)

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, 1)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[row][1] += matrix[row][column]

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:mean(matrix)

	local sum = 0

	local numberOfElements = #matrix * #matrix[1]

	local sum = AqwamRobloxMatrixLibrary:sum(matrix)

	local mean = sum/numberOfElements

	return mean

end

function AqwamRobloxMatrixLibrary:verticalMean(matrix)

	local numberOfRows = #matrix

	local verticalSum = AqwamRobloxMatrixLibrary:verticalSum(matrix)

	local result = AqwamRobloxMatrixLibrary:divide(verticalSum, numberOfRows) 

	return result

end

function AqwamRobloxMatrixLibrary:horizontalMean(matrix)

	local numberOfColumns = #matrix[1]

	local horizontalSum = AqwamRobloxMatrixLibrary:horizontalSum(matrix)

	local result = AqwamRobloxMatrixLibrary:divide(horizontalSum, numberOfColumns)

	return result

end

function AqwamRobloxMatrixLibrary:standardDeviation(matrix)

	local mean = AqwamRobloxMatrixLibrary:mean(matrix)

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

	return standardDeviation	

end

function AqwamRobloxMatrixLibrary:verticalStandardDeviation(matrix)

	local verticalMean = AqwamRobloxMatrixLibrary:verticalMean(matrix)

	local matrixSubtractedByMean = AqwamRobloxMatrixLibrary:subtract(matrix, verticalMean)

	local squaredMatrixSubtractedByMean = AqwamRobloxMatrixLibrary:power(matrixSubtractedByMean, 2)

	local summedSquaredMatrixSubtractedByMean = AqwamRobloxMatrixLibrary:verticalSum(squaredMatrixSubtractedByMean, 2)

	local divisor =  #matrix - 1

	local dividedMatrix = AqwamRobloxMatrixLibrary:divide(summedSquaredMatrixSubtractedByMean, divisor)

	local squareRootMatrix = AqwamRobloxMatrixLibrary:power(dividedMatrix, (1/2))

	return squareRootMatrix

end

function AqwamRobloxMatrixLibrary:horizontalStandardDeviation(matrix)

	local horizontalMean = AqwamRobloxMatrixLibrary:horizontalMean(matrix)

	local matrixSubtractedByMean = AqwamRobloxMatrixLibrary:subtract(matrix, horizontalMean)

	local squaredMatrixSubtractedByMean = AqwamRobloxMatrixLibrary:power(matrixSubtractedByMean, 2)

	local summedSquaredMatrixSubtractedByMean = AqwamRobloxMatrixLibrary:horizontalSum(squaredMatrixSubtractedByMean, 2)

	local divisor =  #matrix[1] - 1

	local dividedMatrix = AqwamRobloxMatrixLibrary:divide(summedSquaredMatrixSubtractedByMean, divisor)

	local squareRootMatrix = AqwamRobloxMatrixLibrary:power(dividedMatrix, (1/2))

	return squareRootMatrix

end

local function generateMatrixString(matrix)

	if matrix == nil then return "" end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local columnWidths = {}

	-- Calculate maximum width for each column
	for column = 1, numberOfColumns do

		local maxWidth = 0

		for row = 1, numberOfRows do

			local cellWidth = string.len(tostring(matrix[row][column]))

			if cellWidth > maxWidth then

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

function AqwamRobloxMatrixLibrary:printMatrix(...)

	local text = "\n\n"

	local generatedText

	local matrices = {...}

	for matrixNumber = 1, #matrices, 1 do

		generatedText = generateMatrixString(matrices[matrixNumber])

		text = text .. generatedText

		text = text .. "\n"

	end

	print(text)

end

function AqwamRobloxMatrixLibrary:horizontalConcatenate(...)

	local matrices = {...}

	local lastMatrixIndex = #matrices
	local secondLastMatrixIndex = lastMatrixIndex - 1 

	local result

	local success = pcall(function()

		result = MatrixConcatenate:horizontalConcatenate(matrices[secondLastMatrixIndex], matrices[lastMatrixIndex])

	end)

	if (not success) then

		local text = generateArgumentErrorString(matrices, secondLastMatrixIndex, lastMatrixIndex)

		error(text)

	end

	if (secondLastMatrixIndex > 1) then

		return AqwamRobloxMatrixLibrary:horizontalConcatenate(select(secondLastMatrixIndex - 1, ...), result)

	else

		return result

	end

end

function AqwamRobloxMatrixLibrary:verticalConcatenate(...)

	local matrices = {...}

	local lastMatrixIndex = #matrices
	local secondLastMatrixIndex = lastMatrixIndex - 1 

	local result

	local success = pcall(function()

		result = MatrixConcatenate:verticalConcatenate(matrices[secondLastMatrixIndex], matrices[lastMatrixIndex])

	end)

	if (not success) then

		local text = generateArgumentErrorString(matrices, secondLastMatrixIndex, lastMatrixIndex)

		error(text)

	end

	if (secondLastMatrixIndex > 1) then

		return AqwamRobloxMatrixLibrary:verticalConcatenate(select(secondLastMatrixIndex - 1, ...), result)

	else

		return result

	end

end


function AqwamRobloxMatrixLibrary:applyFunction(functionToApply, ...)

	local matricesValues

	local matrices = {...}
	local matrix = matrices[1]

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, numberOfColumns)

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

function AqwamRobloxMatrixLibrary:findMaximumValueInMatrix(matrix)

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

function AqwamRobloxMatrixLibrary:findMinimumValueInMatrix(matrix)

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

function AqwamRobloxMatrixLibrary:normalizeMatrix(matrix)

	local mean = AqwamRobloxMatrixLibrary:mean(matrix)

	local standardDeviation = AqwamRobloxMatrixLibrary:standardDeviation(matrix)

	local result = AqwamRobloxMatrixLibrary:subtract(matrix, mean)

	result = AqwamRobloxMatrixLibrary:divide(result, standardDeviation)

	return result

end

function AqwamRobloxMatrixLibrary:verticalNormalizeMatrix(matrix)

	local verticalMean = AqwamRobloxMatrixLibrary:verticalMean(matrix)

	local verticalStandardDeviaton = AqwamRobloxMatrixLibrary:verticalStandardDeviation(matrix)

	local rowVector

	local result = {}

	for row = 1, #matrix, 1 do

		rowVector = AqwamRobloxMatrixLibrary:subtract({matrix[1]}, verticalMean)

		result[row] = AqwamRobloxMatrixLibrary:divide(rowVector, verticalStandardDeviaton)[1]

	end

	return result, verticalMean, verticalStandardDeviaton

end

function AqwamRobloxMatrixLibrary:horizontalNormalizeMatrix(matrix)

	local horizontalMean = AqwamRobloxMatrixLibrary:horizontalMean(matrix)

	local horizontalStandardDeviation = AqwamRobloxMatrixLibrary:horizontalStandardDeviation(matrix)

	local columnVector

	local result

	for column = 1, #matrix[1], 1 do

		columnVector = AqwamRobloxMatrixLibrary:extractColumns(matrix, column, column)

		columnVector = AqwamRobloxMatrixLibrary:subtract(columnVector, horizontalMean)

		columnVector = AqwamRobloxMatrixLibrary:divide(columnVector, horizontalStandardDeviation)

		if (result == nil) then

			result = columnVector

		else

			result = AqwamRobloxMatrixLibrary:horizontalConcatenate(result, columnVector)

		end

	end


	return result, horizontalMean, horizontalStandardDeviation

end

local function extract(matrix, startingIndex, endingIndex)

	if (endingIndex == nil) then endingIndex = #matrix end

	if (startingIndex < 0) then error("The starting index must be a positive integer value!") end 

	if (endingIndex < 0) then error("The ending index must be a positive integer value!") end 

	local result = {}

	if (endingIndex >= startingIndex) then

		for index = startingIndex, endingIndex, 1 do

			table.insert(result, matrix[index])

		end

	else

		for index = endingIndex, #matrix do

			table.insert(result, matrix[index])

		end

		for index = 1, startingIndex, 1 do

			table.insert(result, matrix[index])

		end

	end

	return result

end

function AqwamRobloxMatrixLibrary:extractRows(matrix, startingRowIndex, endingRowIndex)

	local result = extract(matrix, startingRowIndex, endingRowIndex)

	return result

end

function AqwamRobloxMatrixLibrary:extractColumns(matrix, startingColumnIndex, endingColumnIndex)

	local transposedMatrix = AqwamRobloxMatrixLibrary:transpose(matrix)

	local result = extract(transposedMatrix, startingColumnIndex, endingColumnIndex)

	result = AqwamRobloxMatrixLibrary:transpose(result)

	return result

end

function AqwamRobloxMatrixLibrary:copy(matrix)

	if (typeof(matrix) == "number") then return matrix end

	local numberOfRows = #matrix

	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, numberOfColumns)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[row][column] = matrix[row][column]

		end

	end

	return result

end

function AqwamRobloxMatrixLibrary:minor(matrix, row, column)

	local size = #matrix

	local minor = {}

	local coroutines = {}

	for i = 1, size - 1 do

		minor[i] = {}

		for j = 1, size - 1 do

			local m_row = i < row and i or i + 1

			local m_col = j < column and j or j + 1

			minor[i][j] = matrix[m_row][m_col]

		end

	end

	return minor

end

function  AqwamRobloxMatrixLibrary:cofactor(matrix, row, column)

	local minor =  AqwamRobloxMatrixLibrary:minor(matrix, row, column)

	local sign = ((row + column) % 2 == 0) and 1 or -1

	return sign *  AqwamRobloxMatrixLibrary:determinant(minor)

end

function AqwamRobloxMatrixLibrary:determinant(matrix)

	local size = #matrix

	if size == 1 then

		return matrix[1][1]

	elseif size == 2 then

		return matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1]

	else

		local det = 0

		for i = 1, size do

			local cofactor =  AqwamRobloxMatrixLibrary:cofactor(matrix, 1, i)

			det = det + matrix[1][i] * cofactor

		end

		return det

	end

end

function AqwamRobloxMatrixLibrary:inverse(matrix)

	if (#matrix ~= #matrix[1]) then return nil end

	local size = #matrix

	local det = AqwamRobloxMatrixLibrary:determinant(matrix)

	if det == 0 then

		return nil -- matrix is not invertible

	elseif size == 1 then

		return {{1 / det}}

	else

		local adjugate = {}

		for i = 1, size do

			adjugate[i] = {}

			for j = 1, size do

				local sign = ((i + j) % 2 == 0) and 1 or -1

				local cof = AqwamRobloxMatrixLibrary:cofactor(matrix, i, j)

				adjugate[i][j] = sign * cof

			end

		end

		local inverse = AqwamRobloxMatrixLibrary:transpose(adjugate)

		for i = 1, size do

			for j = 1, size do

				inverse[i][j] = inverse[i][j] / det

			end

		end

		return inverse

	end

end

function AqwamRobloxMatrixLibrary:isMatrix(matrix)

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

function AqwamRobloxMatrixLibrary:getVersion()

	return libraryVersion

end

return AqwamRobloxMatrixLibrary
