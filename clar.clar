;; Contract name: CLAR
;; Author: 40230
;; Description: Creates a fungible token with a fixed supply.

;; Define the token properties
(define-data-type token
  (object
    (name string)
    (symbol string)
    (total-supply uint256)
    (minter address)
    ;; Mapping to store token balances for each address
    (balances map address uint256)
  )
)

;; Initialize the token data
(define-constant token (token
  (name "Clarity-based Token")
  (symbol "CLAR")
  (total-supply 1000000000000)
  (minter (principal "SP3J4KHKJEZBWCTDXC1KG0BYKQC1XVJVTHB38X10S"))
  (balances (map (address "ST..."))
)

;; Function to mint new tokens
(define-public-function mint (amount uint256)
  (require (equal (caller) (token.minter))
          "Only the minter can mint new tokens.")
  (update-data token
   (set (balances (caller)) (+ (token.balances (caller)) amount))))

;; Function to transfer tokens
(define-public-function transfer (recipient address amount uint256)
  (require (>= (token.balances (caller)) amount)
          "Insufficient balance for transfer.")
  (update-data token
   (set (balances (caller)) (- (token.balances (caller)) amount))
   (set (balances recipient) (+ (token.balances recipient) amount))))

;; Function to get the balance of an address
(define-public-function get-balance (address address)
  (token.balances address))

;; Define a standard interface for querying token information
(define-interface fungible-token
  (name)
  (symbol)
  (total-supply)
  (minter)
  (get-balance address)
)

;; Implement the fungible-token interface
(implement fungible-token token
  (name)
  (symbol)
  (total-supply)
  (minter)
  (get-balance)
)
