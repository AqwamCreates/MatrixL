# API Reference - Matrix Operations - Subtract

## Code Sample

```

local matrix = {
	
	{-100, -100, 100},
	{-100, -100, 100},

}

local result1 = MatrixL:subtract(matrix, matrix, matrix)

local result2 = MatrixL:subtract(matrix, 100)

MatrixL:printMatrix(result1)

MatrixL:printMatrix(result2)

```
## Function

```
subtract(...): matrix
```

## Arguments:

… : any number of matrices or scalar.

## Returns

result: the resultant matrix after operations have been applied.
