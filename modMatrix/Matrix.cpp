#include "Matrix.h"

Matrix::Matrix(
	const size_t _columnCount,
	const size_t _rowCount) :
	columnCount_(_columnCount),
	rowCount_(_rowCount),
	elements_(columnCount_ * rowCount_)
{
}

Matrix::~Matrix()
{
}

size_t Matrix::getColumnCount() const
{
	return columnCount_;
}

size_t Matrix::getRowCount() const
{
	return rowCount_;
}

double& Matrix::operator() (
	const size_t _column,
	const size_t _row)
{
	return elements_[columnCount_ * _row + _column];
}

double Matrix::operator() (
	const size_t _column,
	const size_t _row) const
{
	return elements_[columnCount_ * _row + _column];
}

void Matrix::print() const
{
	for (int j = 0; j < rowCount_; j++)
	{		
		for (int i = 0; i < columnCount_; i++)
		{
			std::cout << (*this)(i, j) << " ";
		}
		std::cout << std::endl;
	}
}

Matrix operator+ (Matrix _first, Matrix _second)
{
	const int 
		columnCount = (const int)_first.getColumnCount(),
		rowCount = (const int)_first.getRowCount();

	Matrix result(columnCount, rowCount);

	for(int i = 0; i < columnCount; i++)
		for (int j = 0; j < rowCount; j++)
		{
			result(i, j) = _first(i, j) + _second(i, j);
		}

	return result;
}

Matrix operator* (Matrix _first, Matrix _second)
{
	const int
		columnCount = (const int)_second.getColumnCount(),
		rowCount = (const int)_first.getRowCount(),
		productCount = (const int)_first.getColumnCount();

	Matrix result(columnCount, rowCount);

	for (int i = 0; i < columnCount; i++)
		for (int j = 0; j < rowCount; j++)
		{
			double sum = 0;
			for (int k = 0; k < productCount; k++)
			{
				sum += _first(k, j) * _second(i, k);
			}

			result(i, j) = sum;
		}

	return result;
}

std::vector<double> operator* (Matrix _first, std::vector<double> _second)
{
	const int		
		rowCount = (const int)_first.getRowCount(),
		productCount = (const int)_first.getColumnCount();

	std::vector<double> result(rowCount);
		
	for (int j = 0; j < rowCount; j++)
	{
		double sum = 0;
		for (int k = 0; k < productCount; k++)
		{
			sum += _first(k, j) * _second[k];
		}

		result[j] = sum;
	}

	return result;
}

Matrix operator* (Matrix _first, const double _second)
{
	const int
		rowCount = (const int)_first.getRowCount(),
		columnCount = (const int)_first.getColumnCount();

	Matrix result(columnCount, rowCount);

	for (int i = 0; i < columnCount; i++)
		for (int j = 0; j < rowCount; j++)
		{
			result(i, j) = _first(i, j) * _second;
		}
	
	return result;
}

std::vector<double> operator+(std::vector<double> _first, std::vector<double> _second)
{
	std::vector<double> result(_first.size());

	for (int i = 0; i < _first.size(); i++)
	{
		result[i] = _first[i] + _second[i];
	}

	return result;
}

std::vector<double> operator-(std::vector<double> _first, std::vector<double> _second)
{
	std::vector<double> result(_first.size());

	for (int i = 0; i < _first.size(); i++)
	{
		result[i] = _first[i] - _second[i];
	}

	return result;
}

std::vector<double> operator*(double _first, std::vector<double> _second)
{
	std::vector<double> result(_second.size());
	for (int i = 0; i < _second.size(); i++)
	{
		result[i] = _first * _second[i];
	}
	return result;
}

Matrix inverse(Matrix _original)
{
	const double det = _original(0, 0) * _original(1, 1) - _original(1, 0) * _original(0, 1);

	Matrix result(2, 2);

	result(0, 0) = _original(1, 1) / det; result(1, 0) = - _original(1, 0) / det;
	result(0, 1) = - _original(0, 1) / det; result(1, 1) = _original(0, 0) / det;

	return result;
}

Matrix transpond(Matrix _original)
{
	const int
		columnCount = (const int)_original.getColumnCount(),
		rowCount = (const int)_original.getRowCount();

	Matrix result(rowCount, columnCount);

	for (int i = 0; i < rowCount; i++)
		for (int j = 0; j < columnCount; j++)
		{
			result(i, j) = _original(j, i);
		}

	return result;

}