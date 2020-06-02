#include "../modLeastSquares/GradientSolver.h"
#include "../modLeastSquares/NewtonGaussSolver.h"

std::vector<double>
transmittersX = { 0, 5, 0 },
transmittersY = { 0, 0, 5 },
distanceValues = { 2, 3, sqrt(29) },
pointStart = { 1.6, 1.6 };


void testGradient()
{
	GradientSolver solver(transmittersX, transmittersY, distanceValues);

	solver.run(pointStart, 0.1);
}

void testNewtonGauss()
{
	NewtonGaussSolver solver(transmittersX, transmittersY, distanceValues);

	solver.run(pointStart);
}

int main()
{
	testNewtonGauss();
}