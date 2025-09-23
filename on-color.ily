\version "2.24.4"

% http://lsr.di.unimi.it/LSR/Item?u=1&id=969
% contributed by Klaus Blum

#(define-markup-command (on-color layout props color arg) (color? markup?)
   (let* ((stencil (interpret-markup layout props arg))
          (X-ext (ly:stencil-extent stencil X))
          (Y-ext (ly:stencil-extent stencil Y)))

     (ly:stencil-add 
       (stencil-with-color
         (ly:round-filled-box X-ext Y-ext 0)
         color)
       stencil)))

%% end of snippet