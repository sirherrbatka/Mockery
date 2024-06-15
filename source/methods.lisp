(cl:in-package #:mockery)


(defmethod invoke* ((controller mocking-controller) label arguments callback)
  (flet ((default ()
           (return-from invoke* (invoke* (default-behavior controller) label arguments callback))))
    (if (endp label)
        (default)
        (let ((calls (gethash (first label) (calls controller))))
          (when (null calls) (default))
          (loop :for cal :across calls
                :do (handler-case
                        (return-from invoke* (invoke* cal (rest label) arguments callback))
                      (no-applicable-mock (e)
                        (declare (ignore e))
                        nil)))
          (default)))))

(defmethod invoke* :around ((controller fundamental-mocking-object) label arguments callback)
  (when (and (times controller) (not (plusp (times controller))))
    (setf *not-applicable* t)
    (error 'no-applicable-mock))
  (unless (funcall (filter controller) label arguments)
    (setf *not-applicable* t)
    (error 'no-applicable-mock))
  (let ((not-applicable nil))
    (let ((*not-applicable* nil))
      (unwind-protect
           (unwind-protect (call-next-method)
             (setf not-applicable *not-applicable*)
             (when (and (not not-applicable)
                        #1=(times controller)
                        (plusp #1#))
               (decf #1#)))
        (setf *not-applicable* not-applicable)))))

(defmethod invoke* ((controller mocked-call) label arguments callback)
  (call-mock-function (callback controller) arguments))

(defmethod invoke* ((controller direct-call) label arguments callback)
  (funcall callback))

(defmethod with-mocking-expansion ((symbol (eql :mock)) body)
  (destructuring-bind (lambda-list lambda-body . rest) body
    `(make-instance 'mocked-call
      :callback (lambda ,lambda-list ,lambda-body)
      ,@rest)))

(defmethod with-mocking-expansion ((symbol (eql :direct)) body)
  `(make-instance 'direct-call ,@body))
