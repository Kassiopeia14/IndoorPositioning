#include "../modMatrix/Matrix.h"

void testMultiplication()
{
	Matrix A(3, 2), B(2, 3);

	A(0, 0) = 1; A(1, 0) = 2; A(2, 0) = 3;
	A(0, 1) = 4; A(1, 1) = 5; A(2, 1) = 6;

	B(0, 0) = 1; B(1, 0) = 2;
	B(0, 1) = 3; B(1, 1) = 4;
	B(0, 2) = 5; B(1, 2) = 6;

	Matrix C = A * B;

	C.print();
}

void testInverse()
{
	Matrix A(2, 2);

	A(0, 0) = 1; A(1, 0) = 2;
	A(0, 1) = 4; A(1, 1) = 5;

	Matrix B = inverse(A);

	Matrix C = A * B;

	B.print();
	C.print();
}

void testTranspond()
{
	Matrix A(3, 2);

	A(0, 0) = 1; A(1, 0) = 2; A(2, 0) = 3;
	A(0, 1) = 4; A(1, 1) = 5; A(2, 1) = 6;

	Matrix B = transpond(A);

	A.print();
	B.print();
}

void testConstMultiplication()
{
	Matrix A(3, 2);

	A(0, 0) = 1; A(1, 0) = 2; A(2, 0) = 3;
	A(0, 1) = 4; A(1, 1) = 5; A(2, 1) = 6;
	
	Matrix B = A * 7;

	B.print();
}

int main()
{
	testConstMultiplication();

	return 0;
}