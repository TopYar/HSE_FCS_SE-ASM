/*
Студент: Дондик Ярослав Витальевич
Группа: БПИ191
Вариант 14
Условие:
Определить множество индексов i, для которых A[i] и B[i] не имеютобщих 
делителей (единицу в роли делителя не рассматривать).   
Входные данные: массивы целых положительных чисел А и B, произвольной длины ≥1000. 
Количество потоков является входным параметром
*/
#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <thread>
#include <set>
#include <mutex>
#include <vector>
#include <ctime> 

using namespace std;
int arrSize = 0,      // количество элементов в массивах
	threadNumber = 0; // количество потоков
vector<int> A, B;     // последовательность чисел A и B
mutex _lock;          // мьютекс для блокировки потока

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
/// <param name="current_thread">Номер текущего потока</param>
/// <param name="count_threads">Общее количество потоков</param>
/// <param name="setIndex">Множество искомых индексов</param>
void gcd_cycle(int current_thread, int count_threads, set<int>& setIndex) {
	for (int i = current_thread; i < A.size(); i += count_threads) {

		// Подсчет наибольшего общего делителя
		unsigned gcd_result = GCD(A[i], B[i]);

		// Если нет общих делителей, кроме 1:
		if (gcd_result == 1) {
			{
				// Блокировка вывода с других потоков
				unique_lock<mutex> locker(_lock);
				cout << "Thread " << current_thread << " found pair of gcd == 1:" <<
					" A[" << i << "] = " << A[i] << " and B[" << i << "] = " << B[i] << "\n";
			}
			// Добавляем индекс в наше множество
			setIndex.insert(i);
		}
	}
}

int main() {
	srand(time(0));
	// Массив индексов, на которых пара чисел не имеет общий делителей
	set<int> setIndexes;
	// Массив потоков
	vector<thread*> thr;

	// Ввод размера массива
	cout << "Please, enter size of an array of integers (>= 1000): ";
	cin >> arrSize;
	while (std::cin.fail() || arrSize < 1000) {
		cout << "Incorrect input. Please, enter your number again: ";
		std::cin.clear();
		std::cin.ignore(256, '\n');
		std::cin >> arrSize;
	}

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

	// Заполнение массивов числами до 100 000
	for (int i = 0; i < arrSize; ++i) {
		A[i] = rand() % 100'000;
		B[i] = rand() % 100'000;
	}

	// Сохраняем время начала работы
	auto begin = std::chrono::steady_clock::now();

	// Создание потоков
	for (int i = 0; i < threadNumber; i++) {
		thr.push_back(new thread{ gcd_cycle, i, threadNumber, ref(setIndexes) });
	}

	// Присоединение потоков
	for (int i = 0; i < threadNumber; i++) {
		thr[i]->join();
		{
			// Блокировка вывода с других потоков
			unique_lock<mutex> locker(_lock);
			cout << "Thread " << i << " was closed\n";
		}
	}

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