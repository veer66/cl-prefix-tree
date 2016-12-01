(defun members->array (members-with-payloads)
  (loop for member-payload in members-with-payloads
     collect (cons (let ((member (car member-payload)))
                     (make-array (length member)
                                 :initial-contents member))
                   (cdr member-payload))))

(defun members-with-payloads->array (members-with-payloads)
  (let* ((len (length members-with-payloads)))
    (make-array len
                :initial-contents
                (members->array members-with-payloads))))

(defun string-list< (a b)                              
  (labels ((recur (a b)
             (cond
               ((and (null a) (null b))
                nil)
               ((null a)
                t)
               ((null b)
                nil)
               ((string< (car a) (car b))
                t)
               ((string> (car a) (car b))
                nil)
               (t
                (recur (cdr a) (cdr b) )))))
    (recur a b)))

(defun make-prefix-tree (members-with-payloads)
  (let* ((tab (make-hash-table :test #'equal))
         (sorted-members-payload (sort members-with-payloads
                                    (lambda (a b)
                                      (string-list< (car a)
                                                    (car b)))))
         (members-payload-vec (members-with-payloads->array
                               sorted-members-payload)))
    (loop for i from 0 below (length members-payload-vec)
       do (let* ((members-payload (elt members-payload-vec i))
                 (members (car members-payload))
                 (payload (cadr members-payload))
                 (row-no 0))
            (loop for j from 0 below (length members)
               do (let* ((is-terminal (eq (+ j 1) (length members)))
                         (member (elt members j))
                         (r (gethash (list row-no j member) tab)))
                    (setq row-no (if r
                                     (car r)
                                     (let ((key (list row-no j member))
                                           (val (list i is-terminal (when is-terminal
                                                                      payload))))

                                       (setf (gethash key tab)
                                             val)
                                       i)))))))
    tab))
         
(defun prefix-tree-seek (prefix-tree row-no offset member)
  (gethash (list row-no offset member)
           prefix-tree))
