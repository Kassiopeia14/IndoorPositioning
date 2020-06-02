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
		routerYValues = routerNet_.getYValues(),
		xValues(xValues_.begin(), xValues_.end()),
		yValues(yValues_.begin(), yValues_.end());

	for (auto item = rssiData_.begin(); item != rssiData_.end(); item++)
	{
		for (int i = 0; i < routerCount; i++)
		{
			int rssi = (*item)[i];
			if (rssi < 100)
			{
				double distance = sqrt((routerXValues[i] - xValues[i]) * (routerXValues[i] - xValues[i]) + (routerYValues[i] - yValues[i]) * (routerYValues[i] - yValues[i]));
				rssiCounts[i]++;
				result[i] += rssi + 20 * log10(distance);
			}
		}
	}

	for (int i = 0; i < routerCount; i++)
	{
		result[i] /= rssiCounts[i];
	}

	return result;
}

void trackBuilder::calculateDistances()
{
	const size_t routerCount = routerNet_.getRouterCount();

	std::vector<double> p0Values = calculateP0Values();

	for (auto rssiItem = rssiData_.begin(); rssiItem != rssiData_.end(); rssiItem++)
	{
		std::vector<double> distancesLine(routerCount);
		for (int i = 0; i < routerCount; i++)
		{
			const int rssi = (*rssiItem)[i];
			distancesLine[i] = (rssi == 100 ? -1 : exp(log(10) * (p0Values[i] - rssi) / 20));
		}
		distancesData_.emplace_back(distancesLine);
	}
}
