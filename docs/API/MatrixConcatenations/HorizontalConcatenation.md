# [API Reference](../../API.md) - [Matrix Concatenations](../MatrixConcatenations.md) - Horizontal Concatenation

## Code Sample

```

local matrix = {
	
	{-42, 321},
	{-23, -10),
  	{3, -1}

}

local result1 = MatrixL:horizontalConcatenate(matrix, matrix, matrix)

local result2 = MatrixL:horizontalConcatenate(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
horizontalConcatenate(...): matrix
```

## Arguments:

… : any number of matrices or scalar.

## Returns

result: the resultant matrix after concatenation has been applied.
