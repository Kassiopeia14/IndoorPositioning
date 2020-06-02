#include "../modIndoorPositioning/RouterNet.h"

int main()
{
	RouterNet routerNet;
	routerNet.loadFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\dep\\geo.csv");

	std::vector<double> 
		routerXValues = routerNet.getXValues(),
		routerYValues = routerNet.getYValues();

	return 0;
}