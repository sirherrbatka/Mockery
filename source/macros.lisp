(cl:in-package #:mockery)


(defmacro block (((&rest label) (&rest arguments)) &body body)
  (with-gensyms (!arguments)
    `(let ((,!arguments (list ,@arguments)))
       (declare (dynamic-extent ,!arguments))
       (invoke '(,@label) ,!arguments (lambda () ,@body)))))

(defmacro with-mocking (mocks &body body)
  `(let ((mockery:*controller*
           (mockery:build-controller :mocks
                                     (list ,@(mapcar (lambda (args)
                                                       (destructuring-bind (symbol label . body) args
                                                         `(list ',label
                                                           ,(with-mocking-expansion symbol body))))
                                                     mocks)))))
     ,@body))
