import "Counter"

transaction(otherAdmin: Address) {
    prepare(signer: auth(BorrowValue, Capabilities) &Account) {
        let adminRef = getAccount(otherAdmin).capabilities.borrow<&Counter.Admin>(Counter.CounterAdminPublicPath)!
        // let adminRef = signer.capabilities.borrow<&Counter.Admin>(Counter.CounterAdminPublicPath)!

        adminRef.increment()
    }

    execute {
        log("Counter incremented successfully")
    }
}