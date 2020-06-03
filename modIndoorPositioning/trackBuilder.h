#pragma once
#include <fstream>
#include <vector>
#include <string>
#include <list>
#include "RouterNet.h"
#include "../modLeastSquares/GradientSolver.h"
#include "../modLeastSquares/NewtonGaussSolver.h"
#include "../modLeastSquares/LevenbergMarquardtSolver.h"

struct TrackingData
{
	int transmitterCount;
	int pointCount;

	double* transmitterX;
	double* transmitterY;
	double* pointX;
	double* pointY;

};

class trackBuilder
{
public:
	trackBuilder(RouterNet& _routerNet);
	~trackBuilder();

	void loadRSSIFromFile(std::wstring _fileName);

	void loadPathFromFile(std::wstring _fileName);

	void calculateDistances();

	void buildTrack();

	void getTrackingData(TrackingData *_trackingData);

private:

	RouterNet& routerNet_;
	
	std::list<std::vector<int>> rssiData_;

	std::list<double>
		xValues_,
		yValues_,
		resultXValues_,
		resultYValues_;

	std::list<std::vector<double>> 
		distancesData_,
		realDistancesData_;

	std::vector<double> calculateP0Values();
};

