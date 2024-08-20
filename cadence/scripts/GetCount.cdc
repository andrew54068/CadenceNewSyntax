import "Counter"

access(all)
fun main(admin: Address): Int {
    let adminRef = getAccount(admin).capabilities.borrow<&Counter.Admin>(Counter.CounterAdminPublicPath)
        ?? panic("Could not borrow the counter reference")

    return adminRef.modifiedCount
}