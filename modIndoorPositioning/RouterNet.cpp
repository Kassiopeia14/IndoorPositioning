#include "RouterNet.h"

RouterNet::RouterNet():
	routerXValues_(),
	routerYValues_()
{
}

RouterNet::~RouterNet()
{
}

void RouterNet::loadFromFile(std::wstring _fileName)
{	
	routerXValues_.clear();
	routerYValues_.clear();

	std::ifstream file(_fileName);
	if (file.is_open())
	{
		while (!file.eof())
		{
			std::vector<char> s(128);
			file.getline((char*)&s[0], 128);

			std::vector<char> name(4);
			file.getline((char*)&name[0], 4, ',');

			double x, y;
			file >> x;
			file.getline((char*)&s[0], 128, ',');
			file >> y;

			routerXValues_.emplace_back(x);
			routerYValues_.emplace_back(y);
		}		

		size_t routerCount = routerXValues_.size();
	}
}

std::vector<double> RouterNet::getXValues() const
{
	return std::vector<double>(routerXValues_.begin(), routerXValues_.end());
}

std::vector<double> RouterNet::getYValues() const
{
	return std::vector<double>(routerYValues_.begin(), routerYValues_.end());
}