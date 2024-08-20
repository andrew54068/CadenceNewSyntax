import "Counter"

transaction {
    prepare(signer: auth(BorrowValue, Capabilities) &Account) {
        let adminRef = signer.storage.borrow<auth(Counter.AdminEntitlement) &Counter.Admin>(from: Counter.CounterAdminStoragePath)!

        adminRef.increment()
    }

    execute {
        log("Counter incremented successfully")
    }
}