--[[

	--------------------------------------------------------------------

	Aqwam's Matrix Library (Aqwam-MatrixL)

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

local module = {}

local function onDotProductError(matrix1Column, matrix2Row)
	
	local errorMessage = "Incompatible Matrix Dimensions: " .. matrix1Column .. " Column(s), " .. matrix2Row .. " Row(s)."
	
	error(errorMessage)
	
end

local function extractColumnFromMatrix(matrix, column)
	
	local maxRows = #matrix
	
	local result = {}
	
	for row = 1, maxRows, 1 do
		
		table.insert(result, matrix[row][column])
		
	end
	
	return result
	
end

local function multiplyRowVector(vector1, vector2)
	
	local result = {}
	
	for i = 1, #vector1, 1 do
		
		table.insert(result, vector1[i] * vector2[i])
		
	end
	
	return  result
	
end

local function calculateVectorSum(vector)
	
	local sum = 0
	
	for i, value in ipairs(vector) do
		
		sum += value
		
	end
	
	return sum
	
end

local function checkIfCanDotProduct(matrix1, matrix2)
	
	local matrix1Column = #matrix1[1]
	local matrix2Row = #matrix2
	
	if (matrix1Column ~= matrix2Row) then
		
		onDotProductError(matrix1Column, matrix2Row)
		
	end
	
end


function module:dotProduct(matrix1, matrix2)
	
	local result = {}
	
	local matrix1Row = #matrix1
	local matrix2Column = #matrix2[1]
	
	local extractedMatrix2Column
	local multipliedRowVector
	local calculatedVectorSum
	
	checkIfCanDotProduct(matrix1, matrix2)
	
	for row = 1, matrix1Row, 1 do
		
		result[row] = {}
		
		for column = 1, matrix2Column, 1 do
			
			extractedMatrix2Column = extractColumnFromMatrix(matrix2, column)
			
			multipliedRowVector = multiplyRowVector(matrix1[row], extractedMatrix2Column)
			
			calculatedVectorSum = calculateVectorSum(multipliedRowVector)
			
			result[row][column] = calculatedVectorSum
			
		end
		
	end
	
	if (#result == 1) and (#result[1] == 1) then
		
		return result[1][1]
		
	else
		
		return result
		
	end
	
end

return module
