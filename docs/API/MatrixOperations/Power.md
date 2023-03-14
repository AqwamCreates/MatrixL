# [API Reference](../../API.md) - [Matrix Operations](../MatrixOperations.md) - Power

## Code Sample

```

local matrix = {
	
	{-100, -100, 100},
	{-100, -100, 100},

}

local result1 = MatrixL:power(matrix, matrix, matrix)

local result2 = MatrixL:power(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
power(...): matrix
```

## Arguments:

… : any number of matrices or scalar. The first argument is the base for second argument, the second argument is the base for third argument, and so on.

## Returns

result: the resultant matrix after operations have been applied.
