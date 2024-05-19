(cl:in-package #:mockery)


(defun insert-mock-into-hash-table (calls-hash-table label spec)
  (labels ((set-at (path &optional (dict calls-hash-table))
             (destructuring-bind (first . rest) path
               (let ((result (gethash first dict)))
                 (when (null result)
                   (setf result (make-array 0 :fill-pointer 0 :adjustable t)
                         (gethash first dict) result))
                 (if (endp rest)
                     (vector-push-extend spec result)
                     (let ((new-controller (make-instance 'mocking-controller)))
                       (vector-push-extend new-controller result)
                       (set-at rest (calls new-controller))))))))
    (set-at (if (listp label) label (list label)))))
