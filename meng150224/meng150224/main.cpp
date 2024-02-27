#include <iostream>
#include <vector>
#include <cmath>
#include <fstream> // �����ļ�������ͷ�ļ�
#include "basic_calc.h"
#include "monte_carlo.h"
// ����һ��ģ�庯��������һ��������Ϊ���������������е�Ԫ��˳��ת
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
	//����������鵥����·��
	std::vector<double> Z = calculate_Z(mb,mbt,mbh);
	double Vx1 = calculate_Vx(u, Z);
	//double Vx1= Vx.back(); //��ȡvectorԪ�����һ��ֵ 
	double p0 = (m0 + mbh) / mbh;
	std::vector<double> p;
	//reason: vector.sizeΪ�޷���������
	for (size_t i = 0; i < mb.size(); ++i) {
		//�������flip
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

	// ������
	int outputChoice;
	std::cout << "Choose output destination:\n1. Command line\n2. File\nEnter your choice: ";
	std::cin >> outputChoice;

	if (outputChoice == 1) {
		std::cout << "Z: ";
		for (double z : Z) {
			std::cout << z << " ";
		}
		std::cout << std::endl;//���л���

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
		std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // ������뻺������ֱ���������з�
		std::cin.get();
	}
	else if (outputChoice == 2) {
		// ���ļ���û�д����Ļ����Զ�������
		std::ofstream file("results.txt");

		// д���ļ�
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

		// �ر��ļ�
		file.close();
	}
	else {
		std::cerr << "Invalid choice. Exiting...\n";
	}

	return 0;
}
