(cl:in-package #:mockery)


(defclass fundamental-mocking-object ()
  ((%times
    :initarg :times
    :accessor times)
   (%filter
    :reader filter
    :initarg :filter))
  (:default-initargs
   :filter (constantly t)
   :times nil))

(defclass mocked-call (fundamental-mocking-object)
  ((%callback
    :initarg :callback
    :reader callback)))

(defclass direct-call (fundamental-mocking-object)
  ())

(defclass mocking-controller (fundamental-mocking-object)
  ((%calls
    :initarg :calls
    :reader calls)
   (%default-behavior
    :initarg :default-behavior
    :reader default-behavior))
  (:default-initargs
   :calls (make-hash-table :test 'eq)
   :default-behavior :error))

(define-condition no-applicable-mock (error)
  ((%label :initarg :label
           :reader no-applicable-mock-label))
  (:default-initargs :label *full-label*
   :report (lambda (object stream)
             (format stream
                     "No applicable mock for call ~a"
                     (no-applicable-mock-label object)))))
