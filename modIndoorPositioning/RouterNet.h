#pragma once
#include <iostream>
#include <fstream> 
#include <vector> 
#include <list>

class RouterNet
{
public:
	RouterNet();
	~RouterNet();

	void loadFromFile(std::wstring _fileName);

	size_t getRouterCount() const;

	std::vector<double> getXValues() const;
	std::vector<double> getYValues() const;

private:

	std::list<double> 
		routerXValues_, 
		routerYValues_;
};