# Дондик Ярослав, БПИ191
[В данной папке](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW1) представлено выполнение первой домашней работы по работе в FASM. Все исходники лежат в [HW1/src/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW1/src), а скриншоты в [HW1/img/](https://github.com/TopYar/HSE_FCS_SE-ASM/tree/master/HW1/img)

## Программа 1
[Полный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW1/src/hello.ASM)<br>
Классическая программа, выводящая Hello world:<br>
- **Код программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/hello1_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/hello1_2.png" alt="" width="400" /> <br>


Добавим в код считывание имени из консоли и поприветствуем введеное имя:

- **Код программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/hello2_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/hello2_2.png" alt="" width="400" /> <br><br>
Как мы видим, в консоль было выведено введенное имя
<br><br>
**Ресурс -** [youtube.com/watch?v=V-97htBBtMI](https://www.youtube.com/watch?v=V-97htBBtMI)

## Программа 2
[Полный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW1/src/bsod.ASM)<br>
Программа, выкидывающая синий экран при запуске от имени администратора:<br>
- **Код программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/bsod1_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/bsod1_2.png" alt="" width="400" /> <br>

Программа работает таким образом:

1. Получение права SeDebugPrivilege. [(подробнее)](https://www.rsdn.org/article/baseserv/privileges.xml#EMC)
2. Установка статуса текущего процесса в критическое значение. [(подробнее)](https://xakep.ru/2018/02/22/windows-critical-process/)
3. Вызов ExitProcess для завершения работы критического процесса
<br><br>
**Ресурс -** [github.com/bytecode77/bsod-fasm](https://github.com/bytecode77/bsod-fasm)

## Программа 3
[Полный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW1/src/gradient.ASM)<br>
Пример создания градиентов:<br>
- **Часть кода программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/gradient1_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/gradient1_2.png" alt="" width="400" /> <br>


Изменим размеры окна и проверим результат:

- **Часть кода программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/gradient2_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/gradient2_2.png" alt="" width="400" /> <br><br>
Как мы видим, в результате окна поменяли свой размер
<br><br>
**Ресурс -** [board.flatassembler.net/topic.php?t=15278](https://board.flatassembler.net/topic.php?t=15278)

## Программа 4
[Полный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW1/src/game.ASM)<br>
Пример программы - 2D игры:<br>
- **Часть кода программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/game1_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/game1_2.png" alt="" width="400" /> <br>


Изменим параметры игры, например, увеличив скорость передвижения корабля, и проверим результат:

- **Часть кода программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/game2_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/game2_2.png" alt="" width="400" /> <br><br>
Как мы видим шлейф стал больше, и передвижение стало более быстрым
<br><br>
**Ресурс -** [board.flatassembler.net/topic.php?t=15746](https://board.flatassembler.net/topic.php?t=15746)


## Программа 5
[Полный код](https://github.com/TopYar/HSE_FCS_SE-ASM/blob/master/HW1/src/ceil.asm)<br>
Следующая программа посвящена 3D анимации:<br>
- **Часть кода программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/ceil1_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/ceil1_2.png" alt="" width="400" /> <br>


Изменим скорость анимации и название окна

- **Код программы**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/ceil2_1.png" alt="" width="400" /> <br>
- **Выполнение**<br><br>
<img src="https://raw.githubusercontent.com/TopYar/HSE_FCS_SE-ASM/master/HW1/img/ceil2_2.png" alt="" width="400" /> <br><br>
Как мы видим анимация стала быстрее, а название окна поменялось
<br><br>
**Ресурс -** [board.flatassembler.net/topic.php?t=15326](https://board.flatassembler.net/topic.php?t=15326)

