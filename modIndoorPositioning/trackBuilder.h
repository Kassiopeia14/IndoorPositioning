#pragma once
#include <fstream>
#include <vector>
#include <string>
#include <list>
#include "RouterNet.h"

class trackBuilder
{
public:
	trackBuilder(RouterNet& _routerNet);
	~trackBuilder();

	void loadRSSIFromFile(std::wstring _fileName);

	void loadPathFromFile(std::wstring _fileName);

	std::vector<double> calculateP0Values();


private:

	RouterNet& routerNet_;
	
	std::list<std::vector<double>> rssiData_;

	std::list<double>
		xValues_,
		yValues_;

};

