#pragma once
#ifndef MONTE_CARLO_H
#define MONTE_CARLO_H

#include <vector>

void monte_carlo(const std::vector<double>& u, const std::vector<double>& S, double Vx, std::vector<double>& Z_0, std::vector<double>& P_0, double& P0_0);

#endif // MONTE_CARLO_H
