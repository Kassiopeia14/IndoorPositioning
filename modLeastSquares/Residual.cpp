#include "Residual.h"

Residual::Residual(
	std::vector<double> _transmittersX,
	std::vector<double> _transmittersY,
	std::vector<double> _distanceValues) :
	transmittersCount_(_distanceValues.size()),
	transmittersX_(_transmittersX),
	transmittersY_(_transmittersY),
	distanceValues_(_distanceValues)
{
}

Residual::~Residual()
{
}

std::vector<double> Residual::operator ()(const double _x, const double _y)
{
	std::vector<double> result(transmittersCount_);

	for (int i = 0; i < transmittersCount_; i++)
	{
		result[i] = residual(i, _x, _y);
	}

	return result;
}

Matrix Residual::jacobiMatrix(const double _x, const double _y)
{
	Matrix result(2, transmittersCount_);

	for (int i = 0; i < transmittersCount_; i++)
	{
		result(0, i) = residualXDerivative(i, _x, _y);
		result(1, i) = residualYDerivative(i, _x, _y);
	}
	return result;
}

double Residual::targetFunction(const double _x, const double _y)
{
	double result = 0;

	for (int i = 0; i < transmittersCount_; i++)
	{
		result += sqr(residual(i, _x, _y));
	}

	return result;
}

double Residual::distance(const size_t _index, const double _x, const double _y)
{
	return sqrt(sqr(_x - transmittersX_[_index]) + sqr(_y - transmittersY_[_index]));
}

double Residual::residual(const size_t _index, const double _x, const double _y)
{
	return distance(_index, _x, _y) - distanceValues_[_index];
}

double Residual::residualXDerivative(const size_t _index, const double _x, const double _y)
{
	return (_x - transmittersX_[_index]) / distance(_index, _x, _y);
}

double Residual::residualYDerivative(const size_t _index, const double _x, const double _y)
{
	return (_y - transmittersY_[_index]) / distance(_index, _x, _y);
}