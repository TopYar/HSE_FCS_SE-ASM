/*
Студент: Дондик Ярослав Витальевич
Группа: БПИ191
Вариант 14
Условие:
Определить множество индексов i, для которых A[i] и B[i] не имеют общих
делителей (единицу в роли делителя не рассматривать).
Входные данные: массивы целых положительных чисел А и B, произвольной длины ≥1000.
Количество потоков является входным параметром
*/
#include <iostream>
#include <iomanip>
#include <limits>
#include <set>
#include <vector>
#include <ctime>
#include <omp.h> 
#include <chrono>

using namespace std;

const int arrSize = 1000;   // количество элементов в массивах

int threadNumber = 0;		// количество потоков (задается через консоль, согласно условию)
vector<int> A, B;			// последовательность чисел A и B

/// <summary>
/// Вычисление наибольшего общего делителя
/// </summary>
/// <param name="u">Первое число</param>
/// <param name="v">Второе число</param>
/// <returns>Наибольший общий делитель переданных чисел</returns>
unsigned GCD(unsigned u, unsigned v) {
	while (v != 0) {
		unsigned r = u % v;
		u = v;
		v = r;
	}
	return u;
}

/// <summary>
///  Функция, которую выполняют различные потоки. Каждый поток выполняет свою часть цикла (поставленную задачу)
/// </summary>
/// <param name="setIndex">Множество искомых индексов</param>
void gcd_cycle(set<int>& setIndex) {
#pragma omp parallel num_threads(threadNumber) 
	{
#pragma omp for
		for (int i = 0; i < A.size(); i += 1) {

			// Подсчет наибольшего общего делителя
			unsigned gcd_result = GCD(A[i], B[i]);

			// Если нет общих делителей, кроме 1:
			if (gcd_result == 1) {
				{
					// Блокировка вывода с других потоков
#pragma omp critical(cout)
					{
						cout << "Thread " << omp_get_thread_num() << " found pair of gcd == 1:" <<
							" A[" << i << "] = " << A[i] << " and B[" << i << "] = " << B[i] << "\n";
					}
				}
				// Добавляем индекс в наше множество
				setIndex.insert(i);
			}
		}
		// Завершение потоков
#pragma omp critical(cout)
		{
			cout << "Thread " << omp_get_thread_num() << " finished\n";
		}
	}
}

int main() {
	srand(time(0));
	// Массив индексов, на которых пара чисел не имеет общий делителей
	set<int> setIndexes;

	// Ввод количества потоков
	cout << "Please, enter number of threads: ";
	cin >> threadNumber;
	while (std::cin.fail() || threadNumber < 1) {
		cout << "Incorrect input. Please, enter your number again: ";
		std::cin.clear();
		std::cin.ignore(256, '\n');
		std::cin >> threadNumber;
	}

	// Инициализация массивов с числами
	A = vector<int>(arrSize);
	B = vector<int>(arrSize);

	// Заполнение массивов числами от 100 до 199
	for (int i = 0; i < arrSize; ++i) {
		A[i] = rand() % 100 + 100;
		B[i] = rand() % 100 + 100;
	}

	// Сохраняем время начала работы
	auto begin = std::chrono::steady_clock::now();

	// Выполняем основную задачу параллельно
	gcd_cycle(setIndexes);

	// Останавливаем таймер
	auto end = std::chrono::steady_clock::now();

	// Затраченное время
	auto elapsed_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end - begin);

	// Вывод массива индексов, у которых числа не имеют общих делителей
	cout << "\nSet of indexes: \n";
	for (auto k : setIndexes) {
		cout << k << " ";
	}

	cout << "\n\nElapsed time: " << elapsed_ms.count() << " ms\n";
	return 0;
}