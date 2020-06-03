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
		//transmitterNum 1, 2, 3, 4, 5, 7, 8, 9, 11, 14, 15, 16, 19, 21, 22
		transmittersX = { 15.993,   15.993,  14.069,  14.069,  12.145,  12.145,  10.221,  10.221, 8.297, 6.372 , 4.448, 4.448, 2.524, 0.6, 0.6  },
		transmittersY = { 10.168,   5.384,   7.776,   2.992,   10.168,  0.6,     7.776,   2.992,  5.384, 2.992 , 10.168, 5.384, 2.992, 5.384, 0.6  },
		distanceValues = { 7.37365, 2.59085, 5.37576, 2.03157, 8.36254, 4.51541, 7.69852, 5.8733, 8.21276, 9.721, 13.7812, 11.9274, 13.5684, 15.7059, 15.6457 };

	LevenbergMarquardtSolver solver(transmittersX, transmittersY, distanceValues);

	solver.run({ 3, 5 });
}

int main()
{
	// testGradientSolver();
	// testNewtonGaussSolver();
	testLevenbergMarquardtSolver();

	return 0;
}