;;  A Minesweeper engine in Clojure
;; 
;; Sam Auciello | Marlboro College
;; Jan 2012     | opensource.org/licenses/MIT

;; A single cell the game grid
(defstruct cell
  :has-mine ; whether there is a mine in this cell
  :mark) ; either 'c for checked, 'f for flagged, or nil for neither

(defstruct game
  :
