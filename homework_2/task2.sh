# ●	Задание:
# 1.	Напишите скрипт, который выводит текущее значение переменной PATH и добавляет в неё новую директорию, переданную в качестве аргумента.
# 2.	Объясните, почему изменения переменной PATH, сделанные через терминал, временные, и предложите способ сделать их постоянными.
#       Добавьте команду в файл .bashrc и продемонстрируйте, как перезапустить терминал для применения изменений.

echo $PATH
export PATH="$PATH:$(realpath $1)"
echo $PATH

# Выполнение скрипта осуществляется во временном терминале, изменения в котором не передаются в родительский,
# где был запущен скрипт. Для применения изменений в текущем необходимо запустить скрипт командой source task2.sh folder

# В файл .bashrc была добавлена следующая строка:
# bash ~/scm/mentors_seminar/homework_2/task2.sh ~/scm/mentors_seminar/homework_2/folder

# После перезапуска терминала:
# /usr/local/pgsql/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
# /usr/local/pgsql/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/stud/scm/mentors_seminar/homework_2/folder
# stud@Angara:~$ echo $PATH
# /usr/local/pgsql/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/stud/scm/mentors_seminar/homework_2/folder
# stud@Angara:~$
