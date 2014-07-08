;; global variable maintained by countdown-timer
(setq countdown-timer-end-time nil)
(setq countdown-timer-string "")

;; 
(defun countdown-timer-format-float (interval)
  (let*
      ((interval_seconds (round interval))
       (minutes (/ interval_seconds 60))
       (seconds (% interval_seconds 60)))
    (format "%d:%0.2d" minutes seconds)))
    
(defun countdown-timer-update-string ()
  (if countdown-timer-end-time
      (let* ((current (float-time))
	     (remaining (- countdown-timer-end-time current)))
	(setq countdown-timer-string
	      (concat " "
		      (if (> remaining 0)
			  (countdown-timer-format-float remaining)
			"expired"))))
    ;; If the countdown-timer-end-time variable is not set, then
    ;; we do not display the countdown-timer
    ""))


(defun countdown-timer-setup ()
  (progn
    (setq global-mode-string (append global-mode-string '(countdown-timer-string)))
    (add-hook 'display-time-hook 'countdown-timer-update-string)
    (setq countdown-timer-saved-display-time-interval display-time-interval)
    (setq display-time-interval 1)
    (display-time)))

(defun countdown-timer-start ()
  (interactive)
  (progn
    (if (null (member 'countdown-timer-string global-mode-string))
	(countdown-timer-setup))
    (setq countdown-timer-end-time (+ 300 (float-time)))))

(defun countdown-timer-stop ()
  (interactive)
  (progn
    (remove-hook 'display-time-hook 'countdown-timer-update-string)
    (setq display-time-interval countdown-timer-saved-display-time-interval)
    (setq global-mode-string (remq 'countdown-timer-string global-mode-string))))
