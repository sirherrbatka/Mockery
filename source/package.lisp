(cl:defpackage #:mockery
  (:use #:cl)
  (:import-from #:alexandria
                #:with-gensyms)
  (:shadow cl:block)
  (:export
   #:*controller*
   #:block
   #:build-controller
   #:call-mock-function
   #:direct-call
   #:invoke
   #:invoke*
   #:mocked-call
   #:mocking-controller
   #:with-mocking
   ))
