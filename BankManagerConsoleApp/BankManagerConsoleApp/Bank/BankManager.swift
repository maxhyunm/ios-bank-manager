//
//  BankManager.swift
//  BankManagerConsoleApp
//
//  Created by kyungmin, Max on 2023/07/10.
//

struct BankManager {
    var bank: Bank
    
    mutating func workBankManager() {
        while selectMenu() == .open {
            bank.dailyWork()
        }
    }
    
    func selectMenu() -> Menu {
        Menu.displayMenu()
        print(BankNamespace.inputLabel, terminator: BankNamespace.inputTerminater)
        
        guard let inputMenu = readLine(),
              inputMenu == Menu.open.menuNumber else {
            return Menu.finish
        }
        
        return Menu.open
    }
}
