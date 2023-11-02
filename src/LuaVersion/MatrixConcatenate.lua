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
