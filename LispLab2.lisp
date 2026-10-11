
(defun group-pairs (lst)
  (cond ((null lst) nil)
        ((null (cdr lst)) (list (list (car lst))))
        (t (cons (list (car lst) (cadr lst))
                 (group-pairs (cddr lst))))))

(defun element-of-list-p (element lst)
  (cond ((null lst) nil)
        ((eql element (car lst)) t)
        (t (element-of-list-p element (cdr lst)))))

(defun list-set-union (set1 set2)
  (cond ((null set1) set2)
        ((element-of-list-p (car set1) set2)
         (list-set-union (cdr set1) set2))
        (t (cons (car set1)
                 (list-set-union (cdr set1) set2)))))


(defun check-group-pairs (name input expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (group-pairs input) expected)
          name))

(defun subset-p (set1 set2)
  (cond ((null set1) t)
        ((element-of-list-p (car set1) set2)
         (subset-p (cdr set1) set2))
        (t nil)))

(defun same-set-p (set1 set2)
  (and (subset-p set1 set2)
       (subset-p set2 set1)))

(defun check-list-set-union (name set1 set2 expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (same-set-p (list-set-union set1 set2) expected)
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