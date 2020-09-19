# Дондик Ярослав, БПИ191
[В данной папке](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW2) представлено выполнение второй домашней работы по работе в FASM. Исходники лежат в [HW2/src/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW2/src), а скриншоты в [HW2/img/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW2/img)

## Условие
Разработать программу, использующую динамическое выделение памяти под массив, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B по следующему правилу: <b>заменить все отрицательные числа в массиве на максимум из элементовэ того массива</b>

## Код программы
[Исходный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW2/src/array.ASM)<br>
[Исполняемый файл](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW2/src/array.EXE)<br><br>
Рассмотрим часть кода, относящегося к процедурам:<br>
- **Процедура ввода массива**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc1.png" alt="" width="700" /> <br><br>
- **Решение основной задачи (замена отрицательных чисел на максимум из массива)**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc3.png" alt="" width="550" /> <br><br>
- **Процедура вывода массива**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc2.png" alt="" width="550" /> <br><br>

## Тестирование программы
- **Тест 1**<br>
Введем простенький массив, в котором максимальный элемент окажется -1, тогда все остальные элементы заменятся на -1:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/arr1.png" alt="" width="350" /> <br>
Программа отработала успешно <br><br>
- **Тест 2**<br>
Введем другой массив, в котором максимальный элемент окажется положительным, тогда все остальные <b> отрицательные элементы </b> заменятся на этот максимум:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/arr2.png" alt="" width="300" /> <br>
Программа отработала успешно <br><br>
- **Тест 3**<br>
Введем массив посложнее и проверим правильность выполнения программы:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/arr3.png" alt="" width="300" /> <br>
Программа отработала должным образом
