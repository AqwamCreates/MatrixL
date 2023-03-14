# [API Reference](../../API.md) - [Matrix Operations](../MatrixOperations.md) - Add

## Code Sample

```

local matrix = {
	
	{-100, -100, 100},
	{-100, -100, 100},

}

local result1 = MatrixL:add(matrix, matrix, matrix)

local result2 = MatrixL:add(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
add(...): matrix
```

## Arguments:

… : any number of matrices or scalar.

## Returns

result: the resultant matrix after operations have been applied.
