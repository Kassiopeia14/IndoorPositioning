#pragma once

#include "Residual.h"

#include <iostream>

class LevenbergMarquardtSolver
{
public:
	LevenbergMarquardtSolver(
		std::vector<double> _transmittersX,
		std::vector<double> _transmittersY,
		std::vector<double> _distanceValues);
	~LevenbergMarquardtSolver();

	std::vector<double> run(std::vector<double> _startPoint);

private:

	Residual residual_;

};

