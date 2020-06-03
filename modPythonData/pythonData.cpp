#include "pythonData.h"

RouterNet routerNet;

trackBuilder tb(routerNet);

TrackingData trackingData;

TrackingData * importPythonData()
{
	
	routerNet.loadFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\dep\\geo.csv");

	
	tb.loadRSSIFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\rss\\geo_rss.csv");
	tb.loadPathFromFile(L"D:\\projects\\github\\IndoorPositioning\\UJI_BLE_DB\\data\\rss\\geo_crd.csv");

	tb.calculateDistances();

	tb.buildTrack();

	tb.getTrackingData(&trackingData);

	return &trackingData;
}