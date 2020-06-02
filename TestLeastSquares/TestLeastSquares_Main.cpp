#include "../modLeastSquares/GradientSolver.h"
#include "../modLeastSquares/NewtonGaussSolver.h"
#include "../modLeastSquares/LevenbergMarquardtSolver.h"

void testGradientSolver()
{
	std::vector<double>
		transmittersX = { 0, 1, 2, 0, 2, 0, 1, 2 },
		transmittersY = { 0, 0, 0, 1, 1, 2, 2, 2 },
		distanceValues = { sqrt(2), 1, sqrt(2), 1 + 0.1, 1, sqrt(2), 1, sqrt(2) + 0.1 };

	GradientSolver solver(transmittersX, transmittersY, distanceValues);

	solver.run({ 5, 5 }, 0.1);
}

void testNewtonGaussSolver()
{
	std::vector<double>
		transmittersX = { 0, 1, 2, 0, 2, 0, 1, 2 },
		transmittersY = { 0, 0, 0, 1, 1, 2, 2, 2 },
		distanceValues = { sqrt(2), 1, sqrt(2), 1 + 0.1, 1, sqrt(2), 1, sqrt(2) + 0.1 };

	NewtonGaussSolver solver(transmittersX, transmittersY, distanceValues);

	solver.run({ 5, 3 });
}

void testLevenbergMarquardtSolver()
{
	std::vector<double>
		transmittersX = { 0, 1, 2, 0, 2, 0, 1, 2 },
		transmittersY = { 0, 0, 0, 1, 1, 2, 2, 2 },
		distanceValues = { sqrt(2), 1, sqrt(2), 1 + 0.1, 1, sqrt(2), 1, sqrt(2) + 0.1 };

	LevenbergMarquardtSolver solver(transmittersX, transmittersY, distanceValues);

	solver.run({ 5, 3 });
}

int main()
{
	// testGradientSolver();
	// testNewtonGaussSolver();
	testLevenbergMarquardtSolver();

	return 0;
}