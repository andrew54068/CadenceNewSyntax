import "Counter"

transaction {
    prepare(signer: auth(BorrowValue, Capabilities) &Account) {
        let adminRef = signer.capabilities.borrow<&Counter.Admin>(Counter.CounterAdminPublicPath)!

        adminRef.increment()
    }

    execute {
        log("Counter incremented successfully")
    }
}