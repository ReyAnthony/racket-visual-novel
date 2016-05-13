#lang racket
(require 2htdp/universe
         2htdp/image
         "resource.rkt")

(provide moods
         positions
         character
         key-handler
         draw
         MAC-gen-dialog-list)

;Const
(define WIDTH 800)
(define HEIGHT 600)

;Characters moods
(define moods
  '(happy sad laughing neutral angry))

(define positions
  '(left right center))

(define (get-pos pos-id)
  (cond
    [(eq? pos-id 'left) (list 200 320)]
    [(eq? pos-id 'right) (list 600 320)]
    [(eq? pos-id 'center) (list 400 320)]))

;a character
(struct character
  (name mood position [visibility #:mutable] )
  ;transparent allow for debugging because we can see the innards
  #:transparent
  #:guard (λ (name mood position visibility type-name)
            (unless
                (string? name)
              (error "string expected for name in" type-name))
            (unless
                (and
                 (symbol? mood)
                 (member mood moods))
              (error "symbol expected for moods in" type-name))
            (unless
                (and
                 (symbol? position)
                 (member position positions))
              (error "symbol expected for position in" type-name))
            (unless
                (boolean? visibility)
              (error "boolean expected for on-screen in" type-name))
            (values name mood position visibility)))

(define-syntax-rule
  (MAC-gen-dialog-list
   (character message place) ...)
  (list
   (list character message place) ...))

;drawing
;let's draw the content of the pairs
(define (draw state)
  ;LOCAL BINDINGS
  ;STATES
  (define current-state
    (car state))
  (define scene (empty-scene WIDTH HEIGHT))
  ;LOCATION
  (define location
    (third current-state))
  ;SPEAKER
  (define speaking-character
    (car current-state))
  (define speaking-character-text
    (second current-state))
  ;LETS DO THE DRAWING
  (let
      [(positions
        (get-pos(character-position speaking-character)))]
    (place-image
     (text (character-name speaking-character) 20 "white") 100 500
     (place-image
      (text speaking-character-text 25 "white") 400 550
      (place-image
       (bitmap/file "text-board.png") 400 550
       ;need to hide image if on-screen is #f
       (place-image
        (get-char-resource 
         (character-name speaking-character)
         (character-mood speaking-character))
        (first   positions) ;x
        (second  positions) ;y
        (place-image
         (get-background-resource location) 400 300
         scene)))))))

(define (key-handler w a-key)
  (cond
    ;space
    [(key=? a-key " ")
     ;if the next one is a procedure
     ;we apply it
     ;and we return the state after it
     (cond
       [(procedure? (car (second w)))
        ((car (second w)))
        (cdr (cdr w))]
       [else (cdr w)])]
    ;update for nothing ?
    [else w]))