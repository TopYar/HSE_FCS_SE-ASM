# Дондик Ярослав, БПИ191
[В данной папке](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW2) представлено выполнение второй домашней работы по работе в FASM. Исходники лежат в [HW2/src/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW2/src), а скриншоты в [HW2/img/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW2/img)

## Условие
Разработать программу, использующую динамическое выделение памяти под массив, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B по следующему правилу: <b>заменить все отрицательные числа в массиве на максимум из элементов этого массива</b>

## Код программы
[Исходный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW2/src/array.ASM)<br>
[Исполняемый файл](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW2/src/array.EXE)<br><br>
Рассмотрим основную часть кода, которая "вызывает" процедуры:<br>
- **Основная часть кода**<br>
1. Сначала считываем в консоли размер массива, далее резервируем память под наш массив заданного размера. <br>
2. "Вызываем" процедуру ввода массива, в это же время ищем максимум (чтобы лишний раз не проходить по массиву заново). <br>
3. Далее решаем основную часть задачи (замена отрицательных чисел на максимум из массива).<br>
4. В конце, выводим максимальный элемент и новый массив.<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc4.png?v=1.02" alt="" width="700" /> <br><br>
Рассмотрим часть кода, относящегося к процедурам:<br>
- **Процедура ввода массива**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc1.png?v=1.01" alt="" width="700" /> <br><br>
- **Решение основной задачи (замена отрицательных чисел на максимум из массива)**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc3.png?v=1.02" alt="" width="550" /> <br><br>
- **Процедура вывода массива**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/proc2.png?v=1.01" alt="" width="550" /> <br><br>

## Тестирование программы
- **Тест 1**<br>
Для начала проверим проверку ввода на натуральное число:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/console1.png" alt="" width="350" /> <br>
Программа отработала успешно <br><br>
- **Тест 2**<br>
Введем простенький массив, в котором максимальный элемент окажется -1, тогда все остальные элементы заменятся на -1:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/console2.png" alt="" width="350" /> <br>
Программа отработала успешно <br><br>
- **Тест 3**<br>
Введем другой массив, в котором максимальный элемент окажется положительным, тогда все остальные <b> отрицательные элементы </b> заменятся на этот максимум:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/console3.png" alt="" width="300" /> <br>
Программа отработала успешно <br><br>
- **Тест 4**<br>
Введем другой массив, в котором проверим работу вблизи нижней границы:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/console4.png" alt="" width="300" /> <br>
Программа отработала успешно <br><br>
- **Тест 5**<br>
Введем массив посложнее и проверим правильность выполнения программы:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/console5.png" alt="" width="300" /> <br>
Программа отработала должным образом
- **Тест 6**<br>
Введем большой массив и проверим правильность выполнения программы:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW2/img/console6.png" alt="" width="750" /> <br>
Все отрицательные числа заменили на максимум (то есть 100), а неотрицательные числа остались нетронутыми<br>
Программа отработала должным образом
