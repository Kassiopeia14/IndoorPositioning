#pragma once

#include <vector>
#include <iostream>

class Matrix
{
public:
	Matrix(
		const size_t _columnCount, 
		const size_t _rowCount);
	~Matrix();

	size_t getColumnCount() const;
	size_t getRowCount() const;

	double& operator() (
		const size_t _column,
		const size_t _row);

	double operator() (
		const size_t _column,
		const size_t _row) const;

	void print() const;

private:

	const size_t
		columnCount_, 
		rowCount_;

	std::vector<double> elements_;

};


Matrix operator+ (Matrix _first, Matrix _second);

Matrix operator* (Matrix _first, Matrix _second);
std::vector<double> operator* (Matrix _first, std::vector<double> _second);
Matrix operator* (Matrix _first, const double _second);

std::vector<double> operator+ (std::vector<double> _first, std::vector<double> _second);
std::vector<double> operator- (std::vector<double> _first, std::vector<double> _second);
std::vector<double> operator* (double _first, std::vector<double> _second);

Matrix inverse(Matrix _original);
Matrix transpond(Matrix _original);