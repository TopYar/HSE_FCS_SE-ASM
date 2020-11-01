# Дондик Ярослав, БПИ191
[В данной папке](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/MP1) представлено выполнение первого микропроекта по работе в FASM. <br>
Пояснительная записка - [MP1/PZ.pdf](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/MP1/PZ.pdf) <br>
Исходники лежат в [MP1/src/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/MP1/src), а скриншоты в [MP1/img/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/MP1/img)

## Условие
Разработать программу, заменяющую все гласные буквы в заданной ASCII-строке заглавными

## Код программы
[Исходный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/MP1/src/ascii.ASM)<br>
[Исполняемый файл](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/MP1/src/ascii.EXE)<br><br>

Рассмотрим основную часть кода, которая "вызывает" процедуры:<br>
- **Основная часть кода**<br>
1. Сначала считываем из консоли строку <br>
2. Вызываем процедуру проверки символов в данной строке <br>
3. Заменяем строчные гласные на заглавные<br>
4. Выводим новую строку<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/main.png?v=1.00" alt="" width="700" /> <br><br>
Рассмотрим часть кода, относящегося к макросам:<br>
- **Процедура итерации по строке**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/macro1.png?v=1.00" alt="" width="900" /> <br><br>
- **Проверка на строчную гласную букву**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/macro2.png?v=1.00" alt="" width="900" /> <br><br>
- **Процедура подсчета длины строки**<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/macro3.png?v=1.00" alt="" width="550" /> <br><br>

## Тестирование программы
- **Тест 1**<br>
Проверим программу на латинском алфавите (включая строчные и заглавные буквы):<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/test1.png?v=1.00" alt="" width="450" /> <br>
Несложно заметить, что были заменены на заглавные только 6 символов (столько гласных в латинском алфавите). Программа отработала успешно. <br><br>
- **Тест 2**<br>
Проверим программу на тесте с повторениями гласных букв:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/test2.png?v=1.00" alt="" width="350" /> <br>
Несложно заметить, что все строчные гласные были заменены на заглавные, а их количество действительно было 15 штук. Программа отработала успешно. <br><br>
- **Тест 3**<br>
Проверим программу на строку с текстом (то есть включая символы пробела):<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/test3.png?v=1.00" alt="" width="800" /> <br>
Все строчные гласные были заменены на заглавные. Программа отработала успешно. <br><br>
- **Тест 4**<br>
Проверим программу на работу со строкой в 1000 символов (ограничение входных данных):<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/test4.png?v=1.00" alt="" width="800" /> <br>
Все строчные гласные были заменены на заглавные. Программа отработала успешно. <br><br>
- **Тест 5**<br>
Проверим программу на строке, имеющей больше 1000 символов:<br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/MP1/img/test5.png?v=1.00" alt="" width="800" /> <br>
Несложно заметить, что были считаны и заменены на заглавные все 1000 первых символов. Программа отработала успешно. <br><br>
