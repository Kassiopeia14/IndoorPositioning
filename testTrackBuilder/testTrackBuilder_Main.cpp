#include "../modIndoorPositioning/trackBuilder.h"

int main()
{
	RouterNet routerNet;
	routerNet.loadFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\dep\\geo.csv");

	trackBuilder trackBuilder(routerNet);
	trackBuilder.loadRSSIFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\rss\\geo_rss.csv");
	trackBuilder.loadPathFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\rss\\geo_crd.csv");

	trackBuilder.calculateDistances();

	return 0;
}