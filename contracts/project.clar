;; Decentralized Study Notes Repo - Upload/Share for Tokens

;; Define the token used to reward note uploads
(define-fungible-token note-token)

;; Error codes
(define-constant err-note-exists (err u100))
(define-constant err-invalid-hash (err u101))

;; Map to store notes: note-hash => uploader
(define-map notes (buff 32) principal)

;; Upload a study note (hashed content stored on-chain)
(define-public (upload-note (note-hash (buff 32)))
  (begin
    (asserts! (not (is-eq note-hash 0x)) err-invalid-hash)
    (asserts! (is-none (map-get? notes note-hash)) err-note-exists)
    (map-set notes note-hash tx-sender)
    (try! (ft-mint? note-token u10 tx-sender)) ;; Reward uploader with 10 NOTE tokens
    (ok true)))

;; Retrieve the uploader of a given note
(define-read-only (get-note (note-hash (buff 32)))
  (match (map-get? notes note-hash)
    uploader (ok (some uploader))
    (ok none)))
