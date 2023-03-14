# [API Reference](../../API.md) - [Matrix Concatenations](../MatrixConcatenations.md) - Vertical Concatenation

## Code Sample

```

local matrix = {
	
	{-42, 321},
	{-23, -10),
  	{3, -1}

}

local result1 = MatrixL:verticalConcatenate(matrix, matrix, matrix)

local result2 = MatrixL:verticalConcatenate(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
verticalConcatenate(...): matrix
```

## Arguments:

… : any number of matrices or scalar.

## Returns

result: the resultant matrix after concatenation has been applied.
