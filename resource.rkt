#lang racket
(require 2htdp/image)
(provide get-char-resource
         get-background-resource)

;macro for generating conditions for get background
(define-syntax-rule
  (MAC-check-bkg-res (resource-to-check)
                     (resource file) ...)
  (cond
    [(and (file-exists? file) (eq? resource resource-to-check)) 
     (bitmap/file file)]
    ...
    ;missing resource
    [else
     (bitmap/file "warning.png")]))

;macro for generating conditions for get character
(define-syntax-rule
  (MAC-check-char-res (name-to-check
                       mood-to-check)
                      (name mood file) ...)
  (cond
    [(and (file-exists? file) (eq? name name-to-check) (eq? mood mood-to-check))
     (bitmap/file file)]
    ...
    ;missing resource
    [else
     (bitmap/file "warning.png")]))

;resources
(define (get-char-resource name mood)
  (MAC-check-char-res (name mood)
                      ("Joey" 'happy "joey-happy.png")
                      ("Yugi" 'happy "yugi-happy.png")
                      ("Seto Kaiba" 'happy "seto-happy.png")))

(define (get-background-resource resource)
  (MAC-check-bkg-res (resource)
                     ('forest "forest_background.png")
                     ('library "library_background.jpg")
                     ('north-pole "north-pole-background.jpg")))