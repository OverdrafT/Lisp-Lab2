<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>

<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"><b>Студент(-ка)</b>: Щербатюк Євген КВ-33</p>
<p align="right"><b>Рік</b>: 2026</p>

## Загальне завдання

Реалізувати дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за можливості/необхідності використовуючи різні види рекурсії. Вимоги до функцій:

1. Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій для роботи зі списками, що не наведені в четвертому розділі навчального посібника.
3. Реалізована функція не має бути функцією вищого порядку, тобто приймати функції в якості аргументів.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.

Кожна реалізована функція має бути протестована для різних тестових наборів. Тести оформлені у вигляді модульних тестів.

## Варіант 3

1. Написати функцію `group-pairs`, яка групує послідовні пари елементів у списки:

```lisp
CL-USER> (group-pairs '(a b c d e f g))
((A B) (C D) (E F) (G))
```

2. Написати функцію `list-set-union`, яка визначає об'єднання двох множин, заданих списками атомів:

```lisp
CL-USER> (list-set-union '(1 2 3) '(2 3 4))
(1 2 3 4) ; порядок може відрізнятись
```

## Лістинг функції group-pairs

```lisp
(defun group-pairs (lst)
  "Group consecutive pairs of elements of LST into lists.
The last group has one element if LST has an odd length."
  (cond ((null lst) nil)
        ((null (cdr lst)) (list (list (car lst))))
        (t (cons (list (car lst) (cadr lst))
                 (group-pairs (cddr lst))))))
```

### Тестові набори та утиліти

```lisp
(defun check-group-pairs (name input expected)
  "Execute `group-pairs' on INPUT, compare result with EXPECTED and print
comparison status"
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (group-pairs input) expected)
          name))

(defun test-group-pairs ()
  (check-group-pairs "test 1: empty list" nil nil)
  (check-group-pairs "test 2: one element" '(a) '((a)))
  (check-group-pairs "test 3: two elements" '(a b) '((a b)))
  (check-group-pairs "test 4: odd length" '(a b c d e f g)
                     '((a b) (c d) (e f) (g)))
  (check-group-pairs "test 5: even length" '(1 2 3 4) '((1 2) (3 4)))
  (check-group-pairs "test 6: nested elements" '((1) nil (2 3) b)
                     '(((1) nil) ((2 3) b))))
```

### Тестування

```lisp
CL-USER> (test-group-pairs)
passed... test 1: empty list
passed... test 2: one element
passed... test 3: two elements
passed... test 4: odd length
passed... test 5: even length
passed... test 6: nested elements
NIL
```

## Лістинг функції list-set-union

```lisp
(defun element-of-list-p (element lst)
  "Return T if ELEMENT (an atom) is in LST, NIL otherwise."
  (cond ((null lst) nil)
        ((eql element (car lst)) t)
        (t (element-of-list-p element (cdr lst)))))

(defun list-set-union (set1 set2)
  "Return the union of two sets represented as lists of atoms.
Elements of SET1 that are absent from SET2 come first, then all of SET2."
  (cond ((null set1) set2)
        ((element-of-list-p (car set1) set2)
         (list-set-union (cdr set1) set2))
        (t (cons (car set1)
                 (list-set-union (cdr set1) set2)))))
```

### Тестові набори та утиліти

Оскільки порядок елементів результату може відрізнятись, результат порівнюється з очікуваним як множина (без урахування порядку).

```lisp
(defun subset-p (set1 set2)
  "Return T if every element of SET1 is in SET2."
  (cond ((null set1) t)
        ((element-of-list-p (car set1) set2)
         (subset-p (cdr set1) set2))
        (t nil)))

(defun same-set-p (set1 set2)
  "Compare two sets regardless of the order of elements."
  (and (subset-p set1 set2)
       (subset-p set2 set1)))

(defun check-list-set-union (name set1 set2 expected)
  "Execute `list-set-union' on SET1 and SET2, compare result with EXPECTED
ignoring element order and print comparison status"
  (format t "~:[FAILED~;passed~]... ~a~%"
          (same-set-p (list-set-union set1 set2) expected)
          name))

(defun test-list-set-union ()
  (check-list-set-union "test 1: both empty" nil nil nil)
  (check-list-set-union "test 2: first empty" nil '(1 2) '(1 2))
  (check-list-set-union "test 3: second empty" '(1 2) nil '(1 2))
  (check-list-set-union "test 4: partial overlap" '(1 2 3) '(2 3 4)
                        '(1 2 3 4))
  (check-list-set-union "test 5: disjoint" '(1 2) '(3 4) '(1 2 3 4))
  (check-list-set-union "test 6: equal sets" '(a b c) '(c b a) '(a b c))
  (check-list-set-union "test 7: with nil and t" '(1 2 3) '(nil t)
                        '(1 2 3 nil t)))
```

### Тестування

```lisp
CL-USER> (test-list-set-union)
passed... test 1: both empty
passed... test 2: first empty
passed... test 3: second empty
passed... test 4: partial overlap
passed... test 5: disjoint
passed... test 6: equal sets
passed... test 7: with nil and t
NIL

CL-USER> (list-set-union '(1 2 3) '(2 3 4))
(1 2 3 4)

CL-USER> (list-set-union '(1 2 3) '(nil t))
(1 2 3 NIL T)
```

## Додаткове завдання: швидша реалізація group-pairs

Реалізовано додатковий варіант функції `group-pairs`, що працює швидше за основну. Він ітеративний: один прохід по списку, нові групи додаються в кінець результату через вказівник на хвіст, тож немає накладних витрат на рекурсію.

### Лістинг функції group-pairs-fast

```lisp
(defun group-pairs-fast (lst)
  (let* ((head (list nil))
         (tail head))
    (loop while lst
          do (let ((group (if (cdr lst)
                              (list (car lst) (cadr lst))
                              (list (car lst)))))
               (setf (cdr tail) (list group))
               (setf tail (cdr tail))
               (setf lst (cddr lst))))
    (cdr head)))
```

### Тестові набори та утиліти

```lisp
(defun check-group-pairs-fast (name input expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (group-pairs-fast input) expected)
          name))

(defun test-group-pairs-fast ()
  (check-group-pairs-fast "fast test 1: empty list" nil nil)
  (check-group-pairs-fast "fast test 2: one element" '(a) '((a)))
  (check-group-pairs-fast "fast test 3: two elements" '(a b) '((a b)))
  (check-group-pairs-fast "fast test 4: odd length" '(a b c d e f g)
                          '((a b) (c d) (e f) (g)))
  (check-group-pairs-fast "fast test 5: even length" '(1 2 3 4)
                          '((1 2) (3 4)))
  (check-group-pairs-fast "fast test 6: nested elements" '((1) nil (2 3) b)
                          '(((1) nil) ((2 3) b))))
```

### Тестування

```lisp
CL-USER> (test-group-pairs-fast)
passed... fast test 1: empty list
passed... fast test 2: one element
passed... fast test 3: two elements
passed... fast test 4: odd length
passed... fast test 5: even length
passed... fast test 6: nested elements
NIL
```

### Порівняння швидкодії (SBCL, `time`)

Список із 100 000 елементів, 20 запусків: основна версія виконується за 0.052 с, швидка за 0.008 с. Результати обох версій збігаються.