#include "LevenbergMarquardtSolver.h"

LevenbergMarquardtSolver::LevenbergMarquardtSolver(
	std::vector<double> _transmittersX,
	std::vector<double> _transmittersY,
	std::vector<double> _distanceValues) :
	residual_(_transmittersX, _transmittersY, _distanceValues)
{
}

LevenbergMarquardtSolver::~LevenbergMarquardtSolver()
{
}

std::vector<double> LevenbergMarquardtSolver::run(std::vector<double> _startPoint)
{
	std::vector<double> point(_startPoint);

	double 
		distance = 8,
		mu;
		

	std::cout << _startPoint[0] << " " << _startPoint[1] << " " << distance << std::endl;

	size_t i = 0;

	bool begin = true;

	Matrix I(2, 2);
	I(0, 0) = 1; I(1, 0) = 0;
	I(0, 1) = 0; I(1, 1) = 1;

	while (distance > 0.00001)
	{		
		const double
			x = point[0],
			y = point[1];

		bool ok = false;

		while(!ok)
		{	
			Matrix
				jacobiMatrix = residual_.jacobiMatrix(x, y),
				transpondJacobiMatrix = transpond(jacobiMatrix),
				JTJ = transpondJacobiMatrix * jacobiMatrix;			

			std::vector<double> grad = transpondJacobiMatrix * residual_(x, y);
			
			if (begin)
			{
				mu = 10 * maxElement(JTJ);
				begin = false;
			}				

			Matrix
				changedJTJ = JTJ + (mu * I),
				inversedChangedJTJ = inverse(changedJTJ);

			std::vector<double> newPoint = point + (-1) * (inversedChangedJTJ * grad);

			distance = sqrt(sqr(newPoint[0] - x) + sqr(newPoint[1] - y));

			std::cout << newPoint[0] << " " << newPoint[1] << " " << distance << " " << mu << std::endl;

			ok = (residual_.targetFunction(newPoint[0], newPoint[1]) < residual_.targetFunction(x, y));

			if (!ok)
			{
				mu *= 2;
			}

			point = newPoint;
		}
		
		mu /= 2;
		
		i++;
	}

	std::cout << point[0] << " " << point[1] << " " << distance << std::endl;

	return point;
}