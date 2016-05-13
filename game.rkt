#lang racket
(require 2htdp/universe
         "VN.rkt")

;characters
(define yugi
  (character "Yugi" 'happy 'center #t))
(define seto
  (character "Seto Kaiba" 'happy 'right #t))
(define joey
  (character "Joey" 'happy 'left #t))

;dialogs
(define new-dialog-list
  (MAC-gen-dialog-list
   (yugi "C'est l'heure du - dudududu - DUEL !" 'library)
   (seto "Ou pas lolilol" 'library)
   (joey "JE SUIS UN PERSONNAGE SECONDAIRE INUTILE" 'library)
   (seto "Sale histoire" 'library)
   (joey "Oui :'(" 'library)
   (joey "#Se pends" 'library)
   (seto "Bon débarras .." 'library)
   (yugi "Joeeeeey :'(" 'library)
   (yugi "#Se pends" 'library)))

;some slow down issues because of garbage collection
;we give the dialog list to the world
(big-bang new-dialog-list
          (on-key key-handler)
          (to-draw draw)
          (stop-when (λ (state)
                       (null? (cdr state)))))