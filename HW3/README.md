# Дондик Ярослав, БПИ191
[В данной папке](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW3) представлено выполнение третьего домашнего задания по работе с параллельным программированием в C++. <br>
Отчет лежит по этой ссылке- [HW3/readme.pdf](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW3/readme.pdf) <br>
Исходники лежат в [HW3/src/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW3/src), а скриншоты в [HW3/img/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW3/img)

## Вариант 14. Условие

Определить множество индексов i, для которых A[i] и B[i] не имеют общих делителей (единицу в роли делителя не рассматривать).  <br> 
Входные данные: массивы целых положительных чисел А и B, произвольной длины ≥1000. <br>
Количество потоков является входным параметром

## Идея программы
- **Идея программы**<br>
Для выполнения задания был выбран следующий метод построения многопоточных приложений: итеративный параллелизм (все потоки работают над одной задачей-циклом)<br>

Примерный алгоритм работы:<br>
1. С консоли вводится размер массива и требуемое количество потоков<br>
2. Создаются и заполняются два массива указанного размера<br>
3. Запуск потоков, выполняющих свою часть цикла. Сохранение искомых индексов, вывод лог-данных в консоль<br>
4. Вывод ответа и затраченное время на выполнение программы<br>

## Код программы
[Исходный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW3/src/Program.cpp)<br>
[Исполняемый файл](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW3/src/Program.exe)<br><br>

Рассмотрим некоторые части кода, работу потоков и их основную функцию:<br>