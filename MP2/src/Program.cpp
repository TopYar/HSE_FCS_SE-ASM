/*
Студент: Дондик Ярослав Витальевич
Группа: БПИ191
Вариант 14

Условие:
Задача о гостинице-2 (умные клиенты).
В гостинице 10 номеров с ценой 200 рублей, 10 номеров с ценой 400 рублей и
5 номеров с ценой 600 руб. Клиент, зашедший в гостиницу, обладает некоторой суммой и
получает номер по своим финансовым возможностям, если тот свободен. Если среди
доступных клиенту номеров нет свободных, клиент уходит искать ночлег в
другое место. Создать многопоточное приложение, моделирующее работу гостиницы.
*/
#include <iostream>
#include <iomanip>
#include <limits>
#include <thread>
#include <vector>
#include <ctime> 
#include <condition_variable> 
#include <semaphore.h>
#include <string>
#include <random>
#include <sstream>

using namespace std;

bool isInvited = 0;				// получил ли приглашение на ресепшен турист
int threadNumber = 0,			// количество туристов
n200 = 10,						// кол-во свободных номеров за 200, 400 и 600
n400 = 10,
n600 = 5,
finished_tourists = 0;			// количество туристов, зашедших в отель
vector<int> tourists;			// массив туристов с их финансовыми возможностями (количеством денег)

condition_variable cv_tourist;	// условная переменная
mutex _invite_client;			// мьютекс для блокировки туристов (для условной переменной)
								// (чтобы только один турист одновременно обращался в отель)

sem_t sem_cout;					// семафор для блокировки вывода потоков
sem_t hotel_operation;			// семафор для блокировки изменения количества свободных комнат

/// <summary>
/// Метод возвращает текущее время для логгирования
/// </summary>
/// <returns>Строка, формата [hh:mm:ss]</returns>
string getCurrentTime() {
	// Получаем время на компьютере
	time_t rawtime = time(0);
	struct tm timeinfo;
	localtime_s(&timeinfo, &rawtime);

	// Преобразуем полученные значения времени в строку
	stringstream oss;
	int h = timeinfo.tm_hour, m = timeinfo.tm_min, s = timeinfo.tm_sec;
	oss << (h / 10 == 0 ? "0" : "") + to_string(h) << ":" <<
		(m / 10 == 0 ? "0" : "") + to_string(m) << ":" <<
		(s / 10 == 0 ? "0" : "") + to_string(s);
	auto str = oss.str();

	return str;
}

/// <summary>
/// Функци отеля, задача которого состосит в приглашении туристов к ресепшену
/// </summary>
void hotel_function() {
	// Пока не были приглашены все туристы
	while (finished_tourists < threadNumber) {

		// Ждем, пока предыдущий турист не примет приглашение
		if (!isInvited) {
			isInvited = true;
			// Приглашаем туриста на ресепшен
			cv_tourist.notify_one();
		}
		// Ждем следующего приглашения туриста к ресепшену
		this_thread::sleep_for(chrono::milliseconds(300));
	}
}

/// <summary>
/// Метод проверяет наличие свободных комнат и арендует комнату 
/// согласно финансовым возможностям туриста
/// </summary>
/// <param name="thread_num">Номер туриста (потока)</param>
void tourist_function(int thread_num) {
	// Ожидаем приглашения на ресепшен
	{
		unique_lock<mutex> locker(_invite_client);

		// Пока не получим приглашение
		while (!isInvited)
			cv_tourist.wait(locker);

		// Количество приглашенных туристов
		finished_tourists++;

		// Приглашение получили. Восстанавливаем значение по умолчанию
		isInvited = false;
	}

	// Рандом для каждого потока
	srand(time(0) + thread_num);

	// Время отдыха туриста
	int sleep_time = rand() % 15 + 5,
		room_option = 0;

	
	{
		// Блокируем доступ к количеству свободных комнат
		sem_wait(&hotel_operation);

		// Добавляем время в лог
		string log = "[" + getCurrentTime() + "] \t";

		// Если у туриста достаточно денег на свободный номер за 600
		if (tourists[thread_num] >= 600 && n600 > 0) {
			// Занимаем комнату
			n600--;
			// Вычитаем деньги
			tourists[thread_num] -= 600;
			// Выбор туриста
			room_option = 600;

			// Лог с данными о выборе и времени
			log += "Tourist " + to_string(thread_num) + " \trent room with 600 R for " +
				to_string(sleep_time) + " seconds. \tNow " + to_string(n600) + " left\n";
		}
		// Если у туриста достаточно денег на свободный номер за 400
		else if (tourists[thread_num] >= 400 && n400 > 0) {
			n400--;
			tourists[thread_num] -= 400;
			room_option = 400;

			log += "Tourist " + to_string(thread_num) + " \trent room with 400 R for " +
				to_string(sleep_time) + " seconds. \tNow " + to_string(n400) + " left\n";
		}
		// Если у туриста достаточно денег на свободный номер за 200
		else if (tourists[thread_num] >= 200 && n200 > 0) {
			n200--;
			tourists[thread_num] -= 200;
			room_option = 200;

			log += "Tourist " + to_string(thread_num) + " \trent room with 200 R for " +
				to_string(sleep_time) + " seconds. \tNow " + to_string(n200) + " left\n";
		}
		// Если все комнаты заняты, или у него меньше 200 денег
		else {
			log += "Tourist " + to_string(thread_num) +
				" \twent away, because he didn't find free room. (He had " +
				to_string(tourists[thread_num]) + " R)\n";
		}

		// Блокируем для вывода лога
		{
			sem_wait(&sem_cout);
			cout << log;
			sem_post(&sem_cout);
		}

		// Освобождаем доступ к количеству свободных комнат
		sem_post(&hotel_operation);
	}

	// Если комната была свободна
	if (room_option > 0) {

		// Турист отдыхает в комнате заданное время
		this_thread::sleep_for(std::chrono::seconds(sleep_time));

		// Выводим время в лог
		string log = "[" + getCurrentTime() + "] \t";
		log += "Tourist " + to_string(thread_num) +
			" \tleft his room (";

		// Освобождаем комнату (блокируем количество свободных комнат)
		{
			sem_wait(&hotel_operation);
			// Освобождаем комнату, в зависимости от выбора
			switch (room_option)
			{
			case 200:
				n200++;
				log += "for 200 R)\t\tNow " + to_string(n200) + " left\n";
				break;
			case 400:
				n400++;
				log += "for 400 R)\t\tNow " + to_string(n400) + " left\n";
				break;
			case 600:
				n600++;
				log += "for 600 R)\t\tNow " + to_string(n600) + " left\n";
				break;
			default:
				break;
			}
			sem_post(&hotel_operation);
		}

		// Блокируем вывод от других потоков
		{
			sem_wait(&sem_cout);
			cout << log;
			sem_post(&sem_cout);
		}

	}
}


int main() {
	srand(time(0));

	// Массив потоков туристов
	vector<thread*> thr;

	// Ввод количества туристов
	cout << "Please, enter number of tourists: ";
	cin >> threadNumber;

	while (std::cin.fail() || threadNumber < 1) {
		cout << "Incorrect input. Please, enter your number again: ";
		cin.clear();
		cin.ignore(256, '\n');
		cin >> threadNumber;
	}

	// Заполнение массива с финансами в интервале [100; 799]
	for (int i = 0; i < threadNumber; ++i) {
		tourists.push_back(rand() % 700 + 150);
	}

	sem_init(&sem_cout, 0, 1);
	sem_init(&hotel_operation, 0, 1);

	// Создание потоков туристов
	for (int i = 0; i < threadNumber; i++) {
		thr.push_back(new thread{ tourist_function, i });
	}

	// Создание потока, моделирующего поведение отеля
	thr.push_back(new thread{ hotel_function });

	// Присоединение потоков
	for (int i = 0; i < threadNumber + 1; i++) {
		thr[i]->join();
	}
	cout << "\nAll tourists tried to rent a room. Shutdown";

	return 0;
}