#include "NewtonGaussSolver.h"

NewtonGaussSolver::NewtonGaussSolver(
	std::vector<double> _transmittersX,
	std::vector<double> _transmittersY,
	std::vector<double> _distanceValues) :
	residual_(_transmittersX, _transmittersY, _distanceValues)
{
}

NewtonGaussSolver::~NewtonGaussSolver()
{
}

std::vector<double> NewtonGaussSolver::run(std::vector<double> _startPoint)
{
	std::vector<double> point(_startPoint);

	double distance = 8;

	std::cout << _startPoint[0] << " " << _startPoint[1] << " " << distance << std::endl;

	size_t i = 0;

	while (distance > 0.00000001)
	{
		const double
			x = point[0],
			y = point[1];

		Matrix
			jM(residual_.jacobiMatrix(x, y)),
			tM(transpond(jM)),
			inv(inverse(tM));

		std::vector<double> newPoint = point - inv * tM * residual_(x, y);

		distance = sqrt(sqr(newPoint[0] - x) + sqr(newPoint[1] - y));

		if (i % 1 == 0)
		{
			std::cout << newPoint[0] << " " << newPoint[1] << " " << distance << std::endl;
		}

		point = newPoint;

		i++;
	}

	return point;
}