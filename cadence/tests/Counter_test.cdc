import Test
import BlockchainHelpers
import "Counter"

access(all) let administrator = Test.getAccount(0x0000000000000007)
access(all) let admin = Test.createAccount()
access(all) let admin2 = Test.createAccount()

access(all)
fun setup() {

    let err = Test.deployContract(
        name: "Counter",
        path: "../contracts/Counter.cdc",
        arguments: []
    )
    Test.expect(err, Test.beNil())
}

access(all)
fun testCount() {
    // Act
    let count = Counter.count

    
    Test.assertEqual(Counter.getAddress(), Test.getAccount(0x0000000000000007).address)

    // Assert
    Test.assertEqual(0, count)
}

access(all)
fun testAdministratorCreateAdmin() {
    
    let code = Test.readFile("../transactions/createAdministrator.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [administrator.address, admin.address, admin2.address],
        signers: [administrator, admin, admin2],
        arguments: []
    )

    let txResult = Test.executeTransaction(tx)

    Test.expect(txResult, Test.beSucceeded())
}

access(all)
fun testAdminIncrement() {
    
    let code = Test.readFile("../transactions/adminIncrement.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: []
    )

    let txResult = Test.executeTransaction(tx)

    Test.expect(txResult, Test.beSucceeded())
}

access(all)
fun testAdminIncrementByBorrowedCapabilities() {
    
    let code = Test.readFile("../transactions/adminIncrementCapBorrow.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: []
    )

    let txResult = Test.executeTransaction(tx)

    Test.expect(txResult, Test.beFailed())
}

access(all)
fun testAdminGetModifiedCount() {

    let scriptResult = executeScript(
        "../scripts/GetCount.cdc",
        [admin.address]
    )
    Test.expect(scriptResult, Test.beSucceeded())
    Test.assertEqual(scriptResult.returnValue! as! Int, 1)
}

access(all)
fun testAdminIncrementAndGetModifiedCount() {

    testAdminIncrement()

    let scriptResult = executeScript(
        "../scripts/GetCount.cdc",
        [admin.address]
    )
    Test.expect(scriptResult, Test.beSucceeded())
    Test.assertEqual(scriptResult.returnValue! as! Int, 2)
}

access(all)
fun testAdminAccessAdmin2Resource() {
    let code = Test.readFile("../transactions/adminAccessOthers.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin2.address],
        signers: [admin2],
        arguments: [admin.address]
    )

    let txResult = Test.executeTransaction(tx)

    Test.expect(txResult, Test.beFailed())
}