# [API Reference](../../API.md) - [Matrix Operations](../MatrixOperations.md) - Multiply

## Code Sample

```

local matrix = {
	
	{-100, -100, 100},
	{-100, -100, 100},

}

local result1 = MatrixL:multiply(matrix, matrix, matrix)

local result2 = MatrixL:multiply(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
multiply(...): matrix
```

## Arguments:

… : any number of matrices or scalar

## Returns

result: the resultant matrix after operations have been applied.
