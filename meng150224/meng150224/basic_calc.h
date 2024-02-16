#ifndef BASIC_CALC_H
#define BASIC_CALC_H
#include <vector>

std::vector<double> calculate_Z(const std::vector<double>& mb, const std::vector<double>& mbt, double mbh);
std::vector<double> calculate_S(const std::vector<double>& Z, const std::vector<double>& p);
double calculate_Vx(const std::vector<double>& u, const std::vector<double>& Z);
double calculate_P(double p0, const std::vector<double>& p);
//if 多次使用A变量=>使用时请引用
#endif // BASIC_CALC_H
