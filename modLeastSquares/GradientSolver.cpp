#include "GradientSolver.h"

GradientSolver::GradientSolver(
	std::vector<double> _transmittersX,
	std::vector<double> _transmittersY,
	std::vector<double> _distanceValues):
	residual_(_transmittersX, _transmittersY, _distanceValues)
{
}

GradientSolver::~GradientSolver()
{
}

std::vector<double> GradientSolver::run(
	std::vector<double> _startPoint,
	const double _a)
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

		std::vector<double> newPoint = point + (-_a) * (transpond(residual_.jacobiMatrix(x, y)) * residual_(x, y));

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