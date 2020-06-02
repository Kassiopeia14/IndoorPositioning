#pragma once

#include <vector>

#include "../modMatrix/Matrix.h"
#include "Common.h"

class Residual
{
public:
	Residual(
		std::vector<double> _transmittersX, 
		std::vector<double> _transmittersY, 
		std::vector<double> _distanceValues);
	~Residual();

	std::vector<double> operator ()(const double _x, const double _y);

	Matrix jacobiMatrix(const double _x, const double _y);

	double targetFunction(const double _x, const double _y);

private:

	const size_t transmittersCount_;

	std::vector<double>
		transmittersX_,
		transmittersY_,
		distanceValues_;

	double distance(const size_t _index, const double _x, const double _y);
	double residual(const size_t _index, const double _x, const double _y);
	double residualXDerivative(const size_t _index, const double _x, const double _y);
	double residualYDerivative(const size_t _index, const double _x, const double _y);
};

