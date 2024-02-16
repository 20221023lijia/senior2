#include <iostream>
#include <vector>
#include <cmath>
#include <cstdlib>
#include <ctime>

void monte_carlo(const std::vector<double>& u, const std::vector<double>& S, double Vx, std::vector<double>& Z_0, std::vector<double>& P_0, double& P0_0) {
	srand(time(NULL)); // 设置随机种子
	const int N = 500;
	double pmin = 1e10;
	std::vector<std::vector<double>> dV(N, std::vector<double>(3)), Z(N, std::vector<double>(3)), P(N, std::vector<double>(3));
	std::vector<double> P0(N);
	for (int i = 0; i < N; ++i) {
		double k1 = 0.8 + 0.4 * (double)rand() / RAND_MAX;
		double k2 = 0.8 + 0.4 * (double)rand() / RAND_MAX;
		double k3 = 3 - k1 - k2;

		dV[i] = { k1 * Vx / 3, k2 * Vx / 3, k3 * Vx / 3 };//避免使用矩阵的方法
		double product = 1; // 初始化乘积为 1

		for (int j = 0; j < 3; ++j) {
			Z[i][j] = exp(dV[i][j] / u[j]);
			P[i][j] = Z[i][j] * (S[j] - 1) / (S[j] - Z[i][j]);
			//std::cout << Z[i][j] << std::endl;
			product *= P[i][j];
		}

		P0[i] = product; // 将整个向量的乘积赋值给 P0[i]
		//std::cout << "P0[i]:" << P0[i] << std::endl;
		if (P0[i] < pmin) {
			pmin = P0[i];
			Z_0 = Z[i];
			P_0 = P[i];
			P0_0 = P0[i];
		}
	}
}
