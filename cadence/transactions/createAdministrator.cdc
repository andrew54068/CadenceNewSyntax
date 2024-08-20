import "Counter"

transaction() {
    prepare(administrator: auth(BorrowValue) &Account, admin: auth(SaveValue, Capabilities) &Account, admin2: auth(SaveValue, Capabilities) &Account) {
        let administratorRef = administrator.storage.borrow<auth(Counter.AdministratorEntitlement) &Counter.Administrator>(from: Counter.CounterAdministratorStoragePath)!

        admin.storage.save(<- administratorRef.createNewAdmin(), to: Counter.CounterAdminStoragePath)
        let cap = admin.capabilities.storage.issue<auth(Counter.AdminEntitlement) &Counter.Admin>(Counter.CounterAdminStoragePath)
        admin.capabilities.publish(cap, at: Counter.CounterAdminPublicPath)

        admin2.storage.save(<- administratorRef.createNewAdmin(), to: Counter.CounterAdminStoragePath)
        let cap2 = admin2.capabilities.storage.issue<auth(Counter.AdminEntitlement) &Counter.Admin>(Counter.CounterAdminStoragePath)
        admin2.capabilities.publish(cap2, at: Counter.CounterAdminPublicPath)
    }
}
