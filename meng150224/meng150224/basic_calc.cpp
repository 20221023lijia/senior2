#include "basic_calc.h"
#include <cmath>
#include <vector> //err:std无成员函数vector——添加头文件
#include <iostream>

std::vector<double> calculate_Z(const std::vector<double>& mb, const std::vector<double>& mbt, double mbh) {
	std::vector<double> Z;
	for (size_t i = 0; i < mb.size(); ++i) {
		double ml = 0;
		//完美替代flip
		for (size_t j = i; j < mb.size(); ++j) {
			ml += mb[j];
		}
		ml += mbh;
		Z.push_back(ml / (ml - mbt[i]));
	}
	return Z;
}
//----------点乘-----------
std::vector<double> calculate_S(const std::vector<double>& Z, const std::vector<double>& p) {
	std::vector<double> S;
	for (size_t i = 0; i < Z.size(); ++i) {
		S.push_back(Z[i] * (p[i] - 1) / (p[i] - Z[i]));
	}
	return S;
}

//----------累加-----------
double calculate_Vx(const std::vector<double>& u, const std::vector<double>& Z) {
	std::vector<double> Vx(u.size());
	double V=0;//变量必须初始化
	for (size_t i = 0; i < u.size(); ++i) {
		Vx[i] = u[i] * log(Z[i]);
		V += Vx[i];
		//std::cout << "Vx[i]: " << u[0] * log(Z[0]) << std::endl;
		//std::cout << "Vx[i]: " << u[1] * log(Z[1]) << std::endl;
		//std::cout << "Vx[i]: " << u[2] * log(Z[2]) << std::endl;
		//std::cout << "Vx[i]: " << Vx[i] << std::endl;
	}
	return V;
}

//-------累乘------------
double calculate_P(double p0, const std::vector<double>& p) {
	double P = p0;
	for (double pi : p) {
		P *= pi;
	}
	return P;
}
