# [API Reference](../../API.md) - [Matrix Operations](../MatrixOperations.md) - Dot Product

## Code Sample

```

local matrix = {
	
	{-100, -100, 100},
	{-100, -100, 100},

}

local matrix2 = MatrixL:transpose(matrix)

local result1 = MatrixL:dotProduct(matrix, matrix2)

MatrixL:printMatrix(result1)

```
## Function

```
dotProduct(...): matrix
```

## Arguments:

… : any number of matrices or scalar.

## Returns

result: the resultant matrix after operations have been applied.
