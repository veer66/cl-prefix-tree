(require :fiveam)

(load "prefix-tree.lisp")

(5am:def-suite prefix-tree-test-suite)
(5am:in-suite prefix-tree-test-suite)

(5am:test test-basic
  (5am:is (equal (let ((pt (make-prefix-tree '((("A") "P1")))))
                   (prefix-tree-seek pt 0 0 "A"))
                 '(0 t "P1"))))

(5am:test test-2-members
  (let ((pt (make-prefix-tree '((("A") "P1")
                                (("B") "P2")))))
    (5am:is (equal (prefix-tree-seek pt 0 0 "A")
                   '(0 t "P1")))
    (5am:is (equal (prefix-tree-seek pt 0 0 "B")
                   '(1 t "P2")))))


(5am:test test-2-members-len-1-2
  (let ((pt (make-prefix-tree '((("A") "P1")
                                (("A" "B") "P2")))))
    (5am:is (equal (prefix-tree-seek pt 0 0 "A")
                   '(0 t "P1")))
    (5am:is (equal (prefix-tree-seek pt 0 1 "B")
                   '(1 t "P2")))))

(5am:run! 'prefix-tree-test-suite)
