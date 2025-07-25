(define-non-fungible-token mood-nft uint)
(define-fungible-token empathy-token)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-not-found (err u103))
(define-constant err-invalid-mood (err u104))
(define-constant err-insufficient-balance (err u105))

(define-data-var mood-nft-counter uint u0)
(define-data-var total-empathy-distributed uint u0)
(define-data-var emotional-weather uint u5)
(define-data-var last-weather-update uint u0)

(define-map user-moods principal 
  {
    current-mood: uint,
    mood-count: uint,
    last-update: uint,
    empathy-earned: uint
  })

(define-map mood-logs uint
  {
    user: principal,
    mood-score: uint,
    timestamp: uint,
    anonymous-id: (buff 32)
  })

(define-map daily-mood-stats uint
  {
    average-mood: uint,
    total-users: uint,
    positive-count: uint,
    negative-count: uint
  })

(define-map supportive-actions principal
  {
    actions-given: uint,
    actions-received: uint,
    reputation: uint
  })

(define-private (get-day-from-block (height uint))
  (/ height u144))

(define-private (calculate-mood-reward (mood-score uint))
  (if (>= mood-score u7)
    u10
    (if (>= mood-score u4)
      u5
      u15)))

(define-private (update-emotional-weather)
  (let ((current-day (get-day-from-block stacks-block-height)))
    (match (map-get? daily-mood-stats current-day)
      daily-stats
      (let ((avg-mood (get average-mood daily-stats)))
        (var-set emotional-weather avg-mood)
        (var-set last-weather-update stacks-block-height)
        (ok avg-mood))
      (ok (var-get emotional-weather)))))

(define-public (log-mood (mood-score uint) (anonymous-id (buff 32)))
  (let (
    (current-day (get-day-from-block stacks-block-height))
    (nft-id (+ (var-get mood-nft-counter) u1))
    (reward-amount (calculate-mood-reward mood-score))
  )
    (asserts! (and (>= mood-score u1) (<= mood-score u10)) err-invalid-mood)
    
    (try! (nft-mint? mood-nft nft-id tx-sender))
    (var-set mood-nft-counter nft-id)
    
    (map-set mood-logs nft-id {
      user: tx-sender,
      mood-score: mood-score,
      timestamp: stacks-block-height,
      anonymous-id: anonymous-id
    })
    
    (let ((user-data (default-to 
      { current-mood: u5, mood-count: u0, last-update: u0, empathy-earned: u0 }
      (map-get? user-moods tx-sender))))
      (map-set user-moods tx-sender {
        current-mood: mood-score,
        mood-count: (+ (get mood-count user-data) u1),
        last-update: stacks-block-height,
        empathy-earned: (+ (get empathy-earned user-data) reward-amount)
      }))
    
    (let ((daily-data (default-to 
      { average-mood: u5, total-users: u0, positive-count: u0, negative-count: u0 }
      (map-get? daily-mood-stats current-day))))
      (map-set daily-mood-stats current-day {
        average-mood: (let ((current-total (get total-users daily-data))
                           (new-total (+ current-total u1)))
                        (if (> new-total u0)
                          (/ (+ (* (get average-mood daily-data) current-total) mood-score) new-total)
                          mood-score)),
        total-users: (+ (get total-users daily-data) u1),
        positive-count: (if (>= mood-score u6) (+ (get positive-count daily-data) u1) (get positive-count daily-data)),
        negative-count: (if (< mood-score u5) (+ (get negative-count daily-data) u1) (get negative-count daily-data))
      }))
    
    (try! (ft-mint? empathy-token reward-amount tx-sender))
    (var-set total-empathy-distributed (+ (var-get total-empathy-distributed) reward-amount))
    
    (unwrap-panic (update-emotional-weather))
    (ok nft-id)))

(define-public (give-support (recipient principal) (empathy-amount uint))
  (begin
    (try! (ft-transfer? empathy-token empathy-amount tx-sender recipient))
    (ok true)))

(define-public (create-community-mood-session (session-reward uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (ft-mint? empathy-token session-reward tx-sender))
    (ok "Emergency mood session created")))

(define-read-only (get-user-mood (user principal))
  (map-get? user-moods user))

(define-read-only (get-mood-log (nft-id uint))
  (map-get? mood-logs nft-id))

(define-read-only (get-emotional-weather)
  (var-get emotional-weather))

(define-read-only (get-daily-stats (day uint))
  (map-get? daily-mood-stats day))

(define-read-only (get-empathy-balance (user principal))
  (ft-get-balance empathy-token user))

(define-read-only (get-support-stats (user principal))
  (map-get? supportive-actions user))

(define-read-only (get-emotional-gdp)
  (let (
    (total-empathy (var-get total-empathy-distributed))
    (current-weather (var-get emotional-weather))
    (total-nfts (var-get mood-nft-counter))
  )
    {
      total-empathy-circulated: total-empathy,
      emotional-weather-index: current-weather,
      total-mood-entries: total-nfts,
      gdp-score: (if (> current-weather u0) 
                   (/ (* total-empathy current-weather) u100)
                   u0)
    }))

(define-read-only (get-community-health)
  (let ((current-day (get-day-from-block stacks-block-height)))
    (match (map-get? daily-mood-stats current-day)
      daily-stats
      {
        health-score: (get average-mood daily-stats),
        participation: (get total-users daily-stats),
        positivity-ratio: (if (> (get total-users daily-stats) u0)
          (/ (* (get positive-count daily-stats) u100) (get total-users daily-stats))
          u0),
        support-needed: (< (get average-mood daily-stats) u4)
      }
      {
        health-score: u5,
        participation: u0,
        positivity-ratio: u50,
        support-needed: false
      })))

(define-public (reward-supporter (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (ft-mint? empathy-token amount recipient))
    (ok amount)))
