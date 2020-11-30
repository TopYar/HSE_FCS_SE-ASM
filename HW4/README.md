# Дондик Ярослав, БПИ191
[В данной папке](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW4) представлено выполнение четвертого домашнего задания по работе с параллельным программированием в C++. <br>
Отчет лежит по этой ссылке - [HW4/readme.pdf](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW4/readme.pdf) <br>
Исходники лежат в [HW4/src/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW4/src), а скриншоты в [HW4/img/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW4/img)

## Вариант 14. Условие

Определить множество индексов i, для которых A[i] и B[i] не имеют общих делителей (единицу в роли делителя не рассматривать).  <br> 
Входные данные: массивы целых положительных чисел А и B, произвольной длины ≥1000. <br>
Количество потоков является входным параметром

## Идея программы
- **Описание**<br>
Для выполнения задания был выбран следующий метод построения многопоточных приложений: итеративный параллелизм (все потоки работают над одной задачей-циклом)<br>

Примерный алгоритм работы:<br>
1. С консоли вводится требуемое количество потоков<br>
2. Создаются и заполняются два массива указанного размера (константа в начале исходного кода)<br>
3. Запуск потоков, выполняющих свою часть цикла. Сохранение искомых индексов, вывод лог-данных в консоль<br>
4. Вывод ответа и затраченное время на выполнение программы<br>

## Код программы
[Исходный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW4/src/Program.cpp)<br>
[Исполняемый файл](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW4/src/Program.exe)<br><br>

Рассмотрим некоторые части кода, работу потоков и их основную функцию:<br>
- **Основная функция программы (main)**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/main_code.png?v=1.00" alt="" width="500" /> <br><br>
- **Функция поиска индексов взаимнопростых элементов **<br>
Здесь вызывается omp parallel, с указанным количеством потоков.<br>
Далее, вызывается выражение omp for, за которым следует цикл, который будет выполняться параллельно.<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/thread_func.png?v=1.00" alt="" width="700" /> <br><br>
- **Функция поиска наибольшего общего делителя двух чисел (основана на алгоритме Евклида)**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/gcd_func.png?v=1.00" alt="" width="400" /> <br><br>

## Тестирование программы
- **Тест 1**<br>
Проверим программу на некорректном вводе:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test1_1.png?v=1.00" alt="" width="450" /> <br>
После успешного ввода происходит вывод логов от каждого потока:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test1_2.png?v=1.00" alt="" width="450" /> <br>
Далее все потоки закрываются и выводится ответ:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test1_3.png?v=1.00" alt="" width="750" /> <br>
Программа отработала успешно. <br><br>
- **Тест 2**<br>
Проверим программу c большим количеством потоков (10):<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test2_1.png?v=1.00" alt="" width="450" /> <br>
Вывод логов от каждого потока. Некоторые потоки заканчивают свою работу раньше других:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test2_2.png?v=1.00" alt="" width="450" /> <br>
Завершаются оставшиеся потоки и выводится ответ:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test2_3.png?v=1.00" alt="" width="750" /> <br>
Программа отработала успешно. <br><br>
- **Тест 3**<br>
Проверим программу c еще большим количеством потоков (1000):<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test3_1.png?v=1.00" alt="" width="450" /> <br>
Завершение работы потоков и вывод ответа:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test3_2.png?v=1.00" alt="" width="750" /> <br>
Программа отработала успешно. <br><br>
- **Тест 4**<br>
Проверим программу введем размер массива и количество потоков, равными 100000 и 10000 соответственно:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test4_1.png?v=1.01" alt="" width="450" /> <br>
завершение всех потоков:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test4_2.png?v=1.00" alt="" width="250" /> <br>
Вывод ответа. Длительное время работы программы объясняется медленной работой вывода большого количества строчек в консоль: <br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW4/img/test4_3.png?v=1.00" alt="" width="750" /> <br>
Программа отработала успешно. <br><br>

### Источники информации
1. Лекция по OpenMP (2016, Кулаков К.А.) \[Электронный ресурс] // Лекция по OpenMP : \[сайт]. \[2020]. URL:
https://cs.petrsu.ru/~kulakov/courses/parallel/lect/openmp.pdf, режим доступа: свободный, дата обращения:
30.11.2020
2. Выражения (clauses) в OpenMP \[Электронный ресурс] // Microsoft Docs: \[сайт]. \[2020]. URL:
https://docs.microsoft.com/ru-ru/cpp/parallel/openmp/reference/openmp-clauses?view=msvc-160, режим доступа: свободный, дата обращения:
30.11.2020

