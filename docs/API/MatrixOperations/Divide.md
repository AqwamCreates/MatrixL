# [API Reference](../../API.md) - [Matrix Operations](../MatrixOperations.md) - Divide

## Code Sample

```

local matrix = {
	
	{-100, -100, 100},
	{-100, -100, 100},

}

local result1 = MatrixL:divide(matrix, matrix, matrix)

local result2 = MatrixL:divide(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
divide(...): matrix
```

## Arguments:

… : any number of matrices or scalar. The second argument is the denominator for first argument, the third argument is the demoninator for second argument.

## Returns

result: the resultant matrix after operations have been applied.
