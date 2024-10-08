;; title: x

(define-trait sip-010-trait
    (
        ;; Read-only functions
        (get-balance (principal) (response uint uint))
        (get-total-supply () (response uint uint))
        (get-decimals () (response uint uint))
        (get-symbol () (response (string-ascii 12) uint))
        (get-name () (response (string-ascii 32) uint))
        (get-token-uri () (response (optional (string-ascii 256)) uint))
        
        ;; Public functions
        (transfer (uint principal principal (optional (buff 34))) (response bool uint))
        (mint (uint principal) (response bool uint))
    )
)

(define-fungible-token x)

(define-constant ERR_OWNER_ONLY (err u100))
(define-constant ERR_NOT_TOKEN_OWNER (err u101))
(define-constant ERR_INVALID_AMOUNT (err u102))
(define-constant ERR_INVALID_RECIPIENT (err u103))

(define-data-var contract-owner principal tx-sender)
(define-constant TOKEN_URI u"https://zuyux.xyz/metadata.json")
(define-constant TOKEN_NAME "x")
(define-constant TOKEN_SYMBOL "x")
(define-constant TOKEN_DECIMALS u8)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance x who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply x))
)

(define-read-only (get-name)
  (ok TOKEN_NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

(define-read-only (get-token-uri)
  (ok (some TOKEN_URI))
)

(define-public (mint (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR_OWNER_ONLY)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT) 
    (ft-mint? x amount tx-sender)
  )
)

(define-public (transfer
  (amount uint)
  (sender principal)
  (recipient principal)
  (memo (optional (buff 34)))
)
  (begin
    (asserts! (> amount u0) ERR_INVALID_AMOUNT) 
    (asserts! (is-eq tx-sender sender) ERR_NOT_TOKEN_OWNER) 
    (asserts! (is-eq recipient 'SP000000000000000000002Q6VF78) ERR_INVALID_RECIPIENT) 

    (try! (ft-transfer? x amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(begin
    (try! (ft-mint? x u1000000000000000 'ST7FM7445TXTJEJ54GBCV2GJPCJF887NXH5VC99A))
)
