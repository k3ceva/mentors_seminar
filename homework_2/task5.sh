# ●	Задание: Напишите скрипт, который запускает три команды sleep с разными временами в фоновом режиме.
# Используйте команды jobs, fg, bg, чтобы продемонстрировать управление этими задачами. Опишите, что вы наблюдали.

# С помощью команды jobs можно ознакомиться со статусами процессов в фоновом режиме,
# fg необходим для перевода процесса из фонового в активный, а bg позволяет запустить остановленный

# stud@Angara:~/scm/mentors_seminar/homework_2$ sleep 50 &
# sleep 46 &
# sleep 35 &
# [1] 8649
# [2] 8650
# [3] 8651
# stud@Angara:~/scm/mentors_seminar/homework_2$ jobs
# [1]   Запущен          sleep 50 &
# [2]-  Запущен          sleep 46 &
# [3]+  Запущен          sleep 35 &
# stud@Angara:~/scm/mentors_seminar/homework_2$ fg 2
# sleep 46
# ^Z
# [2]+  Остановлен    sleep 46
# stud@Angara:~/scm/mentors_seminar/homework_2$ jobs
# [1]   Запущен          sleep 50 &
# [2]+  Остановлен    sleep 46
# [3]-  Запущен          sleep 35 &
# stud@Angara:~/scm/mentors_seminar/homework_2$ bg 2
# [2]+ sleep 46 &
# stud@Angara:~/scm/mentors_seminar/homework_2$ jobs
# [1]   Запущен          sleep 50 &
# [2]-  Запущен          sleep 46 &
# [3]+  Запущен          sleep 35 &
# stud@Angara:~/scm/mentors_seminar/homework_2$ jobs
# [1]   Запущен          sleep 50 &
# [2]-  Запущен          sleep 46 &
# [3]+  Запущен          sleep 35 &
# stud@Angara:~/scm/mentors_seminar/homework_2$ fg 1
# [3]+  Завершён        sleep 35
# sleep 50
# ^C
# stud@Angara:~/scm/mentors_seminar/homework_2$ jobs
# [2]+  Запущен          sleep 46 &
# stud@Angara:~/scm/mentors_seminar/homework_2$ fg
# [2]+  Завершён        sleep 46
# bash: fg: текущий: нет такого задания
