;; ~/.config/emacs/init.el
;; Example GNU Emacs configuration

;; Prevent loading old byte-code
(setq load-prefer-newer t)

;; Disable UI elements
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Recent files
(recentf-mode 1)

;; Show matching parens
(show-paren-mode 1)

;; Line numbers
(global-display-line-numbers-mode 1)

;; Save history
(savehist-mode 1)

;; Automatically reload files
(global-auto-revert-mode t)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Set default font size (adjust as needed)
(set-face-attribute 'default nil :height 120)

;; Don't create backup~ files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Set package archives
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Initialize if first time
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
