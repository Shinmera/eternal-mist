#|
 This file is a part of ld35
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.ld35)
(in-readtable :qtools)

(define-subject colleen (collidable-subject rotated-subject pivoted-subject sprite-subject savable)
  ((velocity :initarg :velocity :accessor velocity))
  (:default-initargs
   :velocity (vec 0 0 0)
   :location (vec 0 0 0)
   :pivot (vec -25 0 0)
   :name :player
   :animations '((idle 2.0 20 :texture "colleen-idle.png"    :width 50 :height 80)
                 (walk 0.7 20 :texture "colleen-walking.png" :width 50 :height 80))))

(defmethod initialize-instance :after ((colleen colleen) &key)
  (setf *player* colleen))

(define-handler (colleen tick) (ev)
  (with-slots (location velocity angle) colleen
    (cond ((/= 0 (vx velocity))
           (let* ((ang (* (/ angle 180) PI))
                  (vec (nvrot (vec -1 0 0) (vec 0 1 0) ang)))
             (when (< 0.1 (abs (- (vx vec) (vx (vunit velocity)))))
               (incf angle 20)))))
    (nv+ location velocity)))

(define-handler (colleen movement) (ev)
  (with-slots (location velocity) colleen
    (typecase ev
      (start-left
       (setf (vx velocity) -7))
      (start-right
       (setf (vx velocity) 7))
      (start-up
       (setf (vz velocity) -7))
      (start-down
       (setf (vz velocity) 7))
      (stop-left
       (when (< (vx velocity) 0)
         (setf (vx velocity) 0)))
      (stop-right
       (when (< 0 (vx velocity))
         (setf (vx velocity) 0)))
      (stop-up
       (when (< (vz velocity) 0)
         (setf (vz velocity) 0)))
      (stop-down
       (when (< 0 (vz velocity))
         (setf (vz velocity) 0))))
    (if (< 0 (vlength velocity))
        (setf (animation colleen) 'walk)
        (setf (animation colleen) 'idle))))

(defmethod paint ((colleen colleen) target)
  (call-next-method))
