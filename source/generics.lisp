(cl:in-package #:mockery)


(defgeneric invoke* (controller label arguments callback)
  (:documentation "Either calls callback for default implementation, or finds matching mock, depending on the controller.")
  (:method ((controller (eql :default)) label arguments callback)
    (funcall callback))
  (:method ((controller (eql :error)) label arguments callback)
    (error 'no-applicable-mock)))

(defgeneric with-mocking-expansion (symbol body))
