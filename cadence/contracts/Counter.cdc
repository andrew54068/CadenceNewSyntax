access(all) 
contract Counter {
  access(all) entitlement AdministratorEntitlement
  access(all) entitlement AdminEntitlement

  access(all) var count: Int

  access(all) let CounterAdministratorStoragePath: StoragePath

  access(all) let CounterAdminStoragePath: StoragePath

  access(all) let CounterAdminPublicPath: PublicPath

  access(all) fun getAddress(): Address {
    return self.account.address
  }

  access(all)
	resource Administrator {

    access(AdministratorEntitlement)
    fun createNewAdmin(): @Admin {
      return <- create Admin()
    }
  }

  access(all)
  resource Admin {
    access(all) var modifiedCount: Int
    
    access(AdminEntitlement)
    fun increment() {
      Counter.count = Counter.count + 1
      self.modifiedCount = self.modifiedCount + 1
    }

    access(AdminEntitlement)
    fun modifyCount(value: Int) {
      self.modifiedCount = value
    }

    init() {
      self.modifiedCount = 0
    }

  }

  init() {
    self.CounterAdministratorStoragePath = /storage/counterAdministrator
    self.CounterAdminStoragePath = /storage/counterAdmin
    self.CounterAdminPublicPath = /public/counterAdmin
    self.count = 0
    let admin <- create Administrator()
    self.account.storage.save(<-admin, to: self.CounterAdministratorStoragePath)
  }
}