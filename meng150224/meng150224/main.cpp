#include <iostream>
#include <vector>
#include <cmath>
#include <fstream> // 包含文件操作的头文件
#include "basic_calc.h"
#include "monte_carlo.h"
// 定义一个模板函数，接受一个容器作为参数，并将容器中的元素顺序反转
template <typename T>
void flip(T& container) {
	std::reverse(container.begin(), container.end());
}

int main() {
	std::vector<double> u = { 3237, 3000, 2600 }; // m/s
	double mbh = 6.8, m0 = 307.4; // ton
	std::vector<double> mbt = { 160.8, 90.3, 22.3 };
	std::vector<double> mb = { 182, 100, 25.4 };
	std::vector<double> Z_0, P_0;
	double P0_0;
	std::vector<double> ml(mb.size(), 0);
	//共享变量建议单独成路径
	std::vector<double> Z = calculate_Z(mb,mbt,mbh);
	double Vx1 = calculate_Vx(u, Z);
	//double Vx1= Vx.back(); //获取vector元素最后一个值 
	double p0 = (m0 + mbh) / mbh;
	std::vector<double> p;
	//reason: vector.size为无符号整数；
	for (size_t i = 0; i < mb.size(); ++i) {
		//完美替代flip
		for (size_t j = i; j < mb.size(); ++j) {
			ml[i] += mb[j];
		}
		ml[i] += mbh;
	}
	for (size_t i = 0; i < ml.size() - 1; ++i) {
		p.push_back(ml[i] / ml[i + 1]);
	}
	p.push_back(p0 / p[0] / p[1]);

	std::vector<double> S = calculate_S(Z, p);
	double Zs = calculate_P(1, Z);
	double P = calculate_P(1, p);
	monte_carlo(u, S, Vx1, Z_0, P_0, P0_0);

	// 输出结果
	int outputChoice;
	std::cout << "Choose output destination:\n1. Command line\n2. File\nEnter your choice: ";
	std::cin >> outputChoice;

	if (outputChoice == 1) {
		std::cout << "Z: ";
		for (double z : Z) {
			std::cout << z << " ";
		}
		std::cout << std::endl;//进行换行

		std::cout << "P: ";
		for (double pi : p) {
			std::cout << pi << " ";
		}
		std::cout << std::endl;

		std::cout << "Vx: " << Vx1 << std::endl;
		std::cout << "Zs: " << Zs << std::endl;
		std::cout << "P: " << P << std::endl;

		std::cout << "Z_0: ";
		for (double z : Z_0) {
			std::cout << z << " ";
		}
		std::cout << std::endl;
		std::cout << "P_0: ";
		for (double pi : P_0) {
			std::cout << pi << " ";
		}
		std::cout << std::endl;
		std::cout << "P0_0: " << P0_0 << std::endl;
		//bug
		//std::cout << "Press any key to exit...";
		//std::cin.get();
		std::cout << "Press ENTER to exit...";
		std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // 清空输入缓冲区，直到遇到换行符
		std::cin.get();
	}
	else if (outputChoice == 2) {
		// 打开文件（没有创建的话会自动创建）
		std::ofstream file("results.txt");

		// 写入文件
		file << "Z:";
		for (double z : Z) {
			file << z << " ";
		}
		file << "\n";

		file << "P:";
		for (double pi : p) {
			file << pi << " ";
		}
		file << "\n";

		file << "Vx:" << Vx1 << "\n";
		file << "Zs:" << Zs << "\n";
		file << "P:" << P << "\n";

		file << "Z_0:";
		for (double z : Z_0) {
			file << z << " ";
		}
		file << "\n";
		file << "P_0:";
		for (double pi : P_0) {
			file << pi << " ";
		}
		file << "\n";
		file << "P0_0:" << P0_0 << "\n";

		// 关闭文件
		file.close();
	}
	else {
		std::cerr << "Invalid choice. Exiting...\n";
	}

	return 0;
}
