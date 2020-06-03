#include <windows.h>
#include <iostream>
#include "../modIndoorPositioning/trackBuilder.h"

using namespace std;

typedef TrackingData* (*ImportPythonDataMethod)();

void main()
{
	HINSTANCE hModule = NULL;
	hModule = ::LoadLibrary(L"D:\\projects\\github\\IndoorPositioning\\x64\\Debug\\modPythonData.dll");
	if (hModule != NULL)
	{
		ImportPythonDataMethod importPythonDataMethod = (ImportPythonDataMethod)GetProcAddress(hModule, "importPythonData");
		TrackingData* trackingData = (*importPythonDataMethod)();

		for (int i = 0; i < 24; i++)
		{
			std::cout << trackingData->pointX[i] << std::endl;
		}

		::FreeLibrary(hModule);
	}
	else cout << "error load Dll" << endl;
}