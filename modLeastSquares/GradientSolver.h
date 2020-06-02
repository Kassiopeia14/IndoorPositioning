#pragma once

#include "Residual.h"

#include <iostream>

class GradientSolver
{
public:
	GradientSolver(
		std::vector<double> _transmittersX,
		std::vector<double> _transmittersY,
		std::vector<double> _distanceValues);
	~GradientSolver();

	std::vector<double> run(
		std::vector<double> _startPoint,
		const double _a);

private:
	
	Residual residual_;
	
};

