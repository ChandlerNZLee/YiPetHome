export const PAYMENT_STATUS = {
    PENDING: 0,
    SUCCEEDED: 1,
    FAILED: 2,
    CANCELLED: 3,
    REFUNDED: 4,
} as const;

export const ORDER_STATUS = {
    PENDING: 0,
    PROCESSING: 1,
    COMPLETED: 2,
    CANCELLED: 3,
} as const;