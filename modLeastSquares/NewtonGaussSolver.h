#pragma once

#include "Residual.h"

#include <iostream>

class NewtonGaussSolver
{
public:
	NewtonGaussSolver(
		std::vector<double> _transmittersX,
		std::vector<double> _transmittersY,
		std::vector<double> _distanceValues);
	~NewtonGaussSolver();

	std::vector<double> run(std::vector<double> _startPoint);

private:

	Residual residual_;

};

