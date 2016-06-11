;;; Copyright © 2016 Manolis Fragkiskos Ragkousis <manolis837@gmail.com>
;;;

(use-modules (guix packages)
             (guix licenses)
             (guix build-system ruby)
             (gnu packages)
             (gnu packages version-control)
             (gnu packages ssh)
             (gnu packages ruby))

(package
  (name "octopress-ruby-environment")
  (version "1.0")
  (source #f) ; not needed just to create dev environment
  (build-system ruby-build-system)
  ;; These correspond roughly to "development" dependencies.
  (native-inputs
   `(("git" ,git)
     ("ruby-rspec" ,ruby-rspec)))
  (propagated-inputs
   `(("ruby-pg" ,ruby-pg)
     ("ruby-nokogiri" ,ruby-nokogiri)
     ("ruby-i18n" ,ruby-i18n)
     ("bundler" ,bundler)))
  (synopsis "Octopress Ruby Environment")
  (description "This file automates the creation of a ruby environment so I can
blog on octopress.")
  (home-page "http://www.manolisragkousis.com")
  (license expat))
