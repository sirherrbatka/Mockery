(asdf:defsystem #:mockery
  :name "mockery"
  :license "BSD simplified"
  :description "Simplistic mocking library."
  :version "0.0.0"
  :author "Marek Kochanowicz"
  :depends-on (#:alexandria)
  :serial T
  :pathname "source"
  :components ((:file "package")
               (:file "generics")
               (:file "variables")
               (:file "types")
               (:file "macros")
               (:file "methods")
               (:file "functions")))
