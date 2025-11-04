# ●	Задание: Создайте alias для команды ls -la и назовите его ll.
# Напишите команду, чтобы сделать alias постоянным, и объясните, где она должна быть добавлена.
# Продемонстрируйте использование автодополнения на примере команды cd.

alias ll="ls -la" # для постоянства необходимо добавить команду в файл .bashrc

# Пример автодополнения
# stud@Angara:~/scm$ cd mentors_seminar/
# .git/       homework_1/ homework_2/ 
# stud@Angara:~/scm$ cd mentors_seminar/homework_
# homework_1/ homework_2/ 
# stud@Angara:~/scm$ cd mentors_seminar/homework_2/folder/
# stud@Angara:~/scm/mentors_seminar/homework_2/folder$ 
