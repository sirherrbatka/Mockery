(cl:in-package #:mockery)


(declaim (inline invoke))
(defun invoke (label arguments callback)
  "Top level invoke function. Deals with special variables and forwards to invoke* implementation."
  (let ((*full-label* label)
        (*not-applicable* nil))
    (invoke* *controller*
             (if (listp label) label (list label))
             arguments
             callback)))

(defun build-controller (&key mocks)
  (let ((calls (make-hash-table)))
    (loop :for m :in mocks
          :do (insert-mock-into-hash-table calls (first m) (second m)))
    (make-instance 'mocking-controller
                   :calls calls)))

(defun call-mock-function (mock-function arguments)
  "This function is here mostly so it can be traced."
  (apply mock-function arguments))
