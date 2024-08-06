;;; toggle-themes.el --- Toggle between a list of themes -*- lexical-binding: t; -*-

;; Author: Petteri S. <emacs.joyride674@passmail.com>
;; URL: https://github.com/sukkis/toggle-themes
;; Version: 0.1
;; Package-Requires: ((emacs "24.1"))
;; Keywords: themes, convenience
;; License: GPL-3.0-or-later

;;; Commentary:

;; Make changing Emacs colour themes easy
;;
;; There are three ways to change colour theme:
;; 1. interactive function "tet-toggle-colour-theme"
;; 2. toggle function with "C-c t" keybinding
;; 3. with interactive function "tet-change-theme". Write the theme name in buffer.
;;
;;Define your favorite theme in init file. E.g if you like darcula
;;  (setq my-default-theme 'darcula)
;;
;;Also define the list of themes to choose from (ones you have installed).
;;Like so:
;;  (setq my-fav-themes '(autumn-light darcula))

;;; Code:

;; Define a customization group for themes
(defgroup my-themes nil
  "Custom settings for theme management in my package."
  :group 'faces)

;; Define a customizable variable for the default theme
(defcustom my-default-theme 'default-theme
  "The default theme to be used in my package."
  :type 'symbol
  :group 'my-themes)

;; Define a customizable variable for the list of favorite themes
(defcustom my-fav-themes '(theme1 theme2 theme3)
  "A list of favorite themes to be used in my package."
  :type '(repeat symbol)
  :group 'my-themes)

;; Define the package default list of themes
;; Only used if user does not provide a list.
(defvar tet-default-themes '(cyberpunk gruvbox)
  "Default list of colour themes to cycle through.")

;; Define tet-colour-themes to use my-fav-themes if defined, otherwise use the default list
(defvar tet-colour-themes (if (bound-and-true-p my-fav-themes)
                              my-fav-themes
                            tet-default-themes)
  "List of colour themes to cycle through.")

;; Initial theme setup, the package default is cyberpunk,
;; but it will by respect what the user says in init file.
(setq tet-current-theme (or my-default-theme 'cyberpunk))
(load-theme tet-current-theme t)   

(defvar tet-current-theme-index 0
  "Index of the currently selected theme in `tet-colour-themes` list.")

(defvar tet-current-theme nil
  "Currently selected colour theme.")

(defun tet-toggle-colour-theme ()
  "Toggle to the next colour theme in the list."
  (interactive)
  (setq tet-current-theme-index (% (1+ tet-current-theme-index) (length tet-colour-themes)))
  (setq tet-current-theme (nth tet-current-theme-index tet-colour-themes))
  (load-theme (intern (symbol-name tet-current-theme)) t)
  (message "Switched to %s theme" tet-current-theme))


(defun tet-change-theme (name)
  "Applies a colour theme given a theme name.

Usage:
- M-x tet-change-theme <RET>
- <write the theme to change to> <RET>
"
  (interactive "S"
           (let (name (read-from-minibuffer "Enter theme name")))
           )
  (setf tet-current-theme name)
  (load-theme name t)
  (message "Theme set to: %s" name)
  )

(defun tet-get-current-theme ()
  "Display name of the current colour theme."
  (interactive)
  (print tet-current-theme)
  )

(defun tet-list-colour-themes ()
  "List locally available colour themes.
To change to one of the colour themes, use 'tet-change-theme'."
  (interactive)
  (message "List of available colour themes: %s" tet-colour-themes)
  )

(global-set-key (kbd "C-c t") 'tet-toggle-colour-theme)

(provide 'toggle-themes)

;;; toggle-themes.el ends here
