#include "trackBuilder.h"

trackBuilder::trackBuilder(RouterNet& _routerNet):
	routerNet_(_routerNet),
	rssiData_(),
	xValues_(),
	yValues_(),
	distancesData_()
{
}

trackBuilder::~trackBuilder()
{
}

void trackBuilder::loadRSSIFromFile(std::wstring _fileName)
{
	const size_t routerCount = routerNet_.getRouterCount();
	rssiData_.clear();

	std::ifstream file(_fileName);
	if (file.is_open())
	{
		while (!file.eof())
		{
			std::vector<int> rssiLine(routerCount);

			for (int i = 0; i < routerCount; i++)
			{				
				if (i > 0)
				{
					std::string coma(2, 0);
					file.getline((char*)&coma[0], 2, ',');
				}
				int rssi;
				file >> rssi;
				rssiLine[i] = rssi;
			}			
			rssiData_.emplace_back(rssiLine);
		}
	}
}

void trackBuilder::loadPathFromFile(std::wstring _fileName)
{
	xValues_.clear();
	yValues_.clear();

	std::ifstream file(_fileName);
	if (file.is_open())
	{
		while (!file.eof())
		{
			double x, y;
			file >> x;

			std::string coma(2, 0);
			file.getline((char*)&coma[0], 2, ',');

			file >> y;

			xValues_.emplace_back(x);
			yValues_.emplace_back(y);

		}
	}
}

std::vector<double> trackBuilder::calculateP0Values()
{
	const size_t routerCount = routerNet_.getRouterCount();

	std::vector<double> result(routerCount);
	std::vector<int> rssiCounts(routerCount);

	for (int i = 0; i < routerCount; i++)
	{
		result[i] = 0;
		rssiCounts[i] = 0;
	}

	std::vector<double>
		routerXValues = routerNet_.getXValues(),
		routerYValues = routerNet_.getYValues();

	int n = 0;
	auto xValueItem = xValues_.begin();
	auto yValueItem = yValues_.begin();

	for (auto item = rssiData_.begin(); item != rssiData_.end(); item++, xValueItem++, yValueItem++)
	{
		std::vector<double> realDistances(routerCount);

		for (int i = 0; i < routerCount; i++)
		{
			int rssi = (*item)[i];
			if (rssi != 100)
			{
				double distance = sqrt((routerXValues[i] - *xValueItem) * (routerXValues[i] - *xValueItem) + (routerYValues[i] - *yValueItem) * (routerYValues[i] - *yValueItem));
				/*
				if(n==16)
					std::cout << *xValueItem << ", " << *yValueItem << ", " << distance << std::endl;
				*/
				realDistances[i] = distance;

				rssiCounts[i]++;
				result[i] += rssi + 20 * log10(distance);

			}
			else
			{
				realDistances[i] = -1;
			}
		}
		realDistancesData_.emplace_back(realDistances);
		n++;
	}

	for (int i = 0; i < routerCount; i++)
	{
		result[i] /= rssiCounts[i];
		//std::cout << "p0: " << result[i] << std::endl;
	}

	return result;
}

void trackBuilder::calculateDistances()
{
	const size_t routerCount = routerNet_.getRouterCount();

	std::vector<double> p0Values = calculateP0Values();

	auto realDistanceItem = realDistancesData_.begin();
	double ss = 0;
	int n = 0;
	for (auto rssiItem = rssiData_.begin(); rssiItem != rssiData_.end(); rssiItem++, realDistanceItem++)
	{
		std::vector<double> 
			distancesLine(routerCount),
			realDistancesLine(*realDistanceItem);
		
		double distancesDelta = 0;
		int j = 0;
		double s = 0;
		for (int i = 0; i < routerCount; i++)
		{
			const int rssi = (*rssiItem)[i];
			distancesLine[i] = (rssi == 100 ? -1 : exp(log(10) * (p0Values[i] - rssi) / 20));
			
			if (rssi != 100)
			{
				
				distancesDelta += abs(realDistancesLine[i] - distancesLine[i]);
				//std::cout << distancesDelta << std::endl;
				j++;
			}
		}
		distancesData_.emplace_back(distancesLine);

		if (j != 0)
		{
			s = distancesDelta / j;
			n++;
			ss += s;
		}
	}
	ss /= n;
}

void trackBuilder::buildTrack()
{
	const size_t routerCount = routerNet_.getRouterCount();

	std::vector<double>
		routerXValues = routerNet_.getXValues(),
		routerYValues = routerNet_.getYValues(),
		xValues(xValues_.begin(), xValues_.end()),
		yValues(yValues_.begin(), yValues_.end()),
		currentPoint = { 0, 0 };

	double a = 0.1;
	int n = 0,
		success = 0;

	for (auto distancesItem = distancesData_.begin(); distancesItem != distancesData_.end(); distancesItem++)
	{
		std::list<double> transmittersXList;
		std::list<double> transmittersYList;
		std::list<double> distanceValuesList;

		for (int i = 0; i < routerCount; i++)
		{
			const double distance = (*distancesItem)[i];
			if (distance > -1)
			{
				transmittersXList.push_back(routerXValues[i]);
				transmittersYList.push_back(routerYValues[i]);
				distanceValuesList.push_back(distance); //* ( 1.0 + 0.001 * (rand() % 1000)));
			}
		}
		std::vector<double> transmittersX(transmittersXList.begin(), transmittersXList.end());
		std::vector<double> transmittersY(transmittersYList.begin(), transmittersYList.end());
		std::vector<double> distanceValues(distanceValuesList.begin(), distanceValuesList.end());
		/*
		if (n == 1)
		{
			for (auto i = transmittersY.begin(); i != transmittersY.end(); i++)
			{
				std::cout << *i << ", ";
			}
			std::cout << std::endl << std::endl;
		}
		*/
		if (distanceValues.size() > 2)
		{
			LevenbergMarquardtSolver solver(transmittersX, transmittersY, distanceValues);
			std::vector<double> newPoint = solver.run(currentPoint);
			
			if ((newPoint[0] > 0) && (newPoint[1] > 0))
			{
				currentPoint[0] = newPoint[0];
				currentPoint[1] = newPoint[1];

				resultXValues_.push_back(currentPoint[0]);
				resultYValues_.push_back(currentPoint[1]);

				//std::cout << n << ": " << newPoint[0] << ", " << newPoint[1] << std::endl;
				success++;
			}
			else
			{
				//std::cout << n << ": fail!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" << std::endl;
			}
		}
		n++;
	}
	//std::cout << "success: " << success << std::endl;
}

void trackBuilder::getTrackingData(TrackingData* _trackingData)
{
	_trackingData->transmitterCount = routerNet_.getRouterCount();
	
	std::vector<double>
		routerXValues = routerNet_.getXValues(),
		routerYValues = routerNet_.getYValues();

	_trackingData->transmitterX = new double[routerXValues.size()];
	_trackingData->transmitterY = new double[routerXValues.size()];
	for (int i = 0; i < routerXValues.size(); i++)
	{
		_trackingData->transmitterX[i] = routerXValues[i];
		_trackingData->transmitterY[i] = routerYValues[i];
	}

	_trackingData->pointCount = xValues_.size();

	std::vector<double>
		xValues(resultXValues_.begin(), resultXValues_.end()),
		yValues(resultYValues_.begin(), resultYValues_.end());

	_trackingData->pointX = new double[xValues.size()];
	_trackingData->pointY = new double[xValues.size()];
	for (int i = 0; i < routerXValues.size(); i++)
	{
		_trackingData->pointX[i] = xValues[i];
		_trackingData->pointY[i] = yValues[i];
	}
}