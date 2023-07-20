//
//  Bank.swift
//  BankManagerUIApp
//
//  Created by kyungmin, Max on 2023/07/20.
//

import Foundation

class Bank {
    private var depositBankerQueue = OperationQueue()
    private var loanBankerQueue = OperationQueue()
    private var dailyCustomerQueue = CustomerQueue<Customer>()
    private var dailyTotalCustomer: Int = .zero
    weak var delegate: BankViewControllerDelegate?
    
    init() {
        depositBankerQueue.maxConcurrentOperationCount = Configuration.numberOfDepositBanker
        loanBankerQueue.maxConcurrentOperationCount = Configuration.numberOfLoanBanker
    }
    
    
    func work() {
        let totalCustomer = configureCustomer()
        addCustomer(totalCustomer)
        workProcess()
    }
    
    func work(totalCustomer: Int) {
        addCustomer(totalCustomer)
        workProcess()
    }
    
    private func workProcess() {
        while let customer = dailyCustomerQueue.dequeue() {
            addTask(customer)
            delegate?.addWaitingQueue(customer)
        }
    }
    
    func addCustomer(_ totalCustomer: Int) {
        for _ in 1...totalCustomer {
            guard let work = Bank.Work.allCases.randomElement() else {
                continue
            }
            
            dailyTotalCustomer += 1
            
            let customer = Customer(purpose: work.name, duration: work.duration, waitingNumber: dailyTotalCustomer)
            
            dailyCustomerQueue.enqueue(customer)
        }
    }
    
    func configureCustomer() -> Int {
        let totalCustomer = Int.random(
            in: Configuration.minimumCustomer...Configuration.maximumCustomer
        )
        
        return totalCustomer
    }

    private func addTask(_ customer: Customer) {
        let task = BlockOperation {
            self.delegate?.moveCustomerToProcessQueue(customer)
            Thread.sleep(forTimeInterval: customer.duration)
            self.delegate?.popProcessingQueue(customer)
        }
        
        if customer.purpose == Work.deposit.name {
            depositBankerQueue.addOperation(task)
        } else {
            loanBankerQueue.addOperation(task)
        }
    }
    
    func reset() {
        depositBankerQueue.cancelAllOperations()
        loanBankerQueue.cancelAllOperations()
        dailyCustomerQueue.clear()
        dailyTotalCustomer = .zero
        
        self.delegate?.resetUI()
    }
}


extension Bank {
    enum Configuration {
        static let numberOfDepositBanker = 2
        static let numberOfLoanBanker = 1
        static let minimumCustomer = 10
        static let maximumCustomer = 30
    }
}

extension Bank {
    enum Namespace {
        static let startTask = "%d번 고객 %@업무 시작"
        static let endTask = "%d번 고객 %@업무 완료"
        static let closingMessage = "업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 %d명이며, 총 업무시간은 %.2f초입니다."
    }
}

extension Bank {
    enum Work: CaseIterable {
        case deposit
        case loan
        
        var duration: Double {
            switch self {
            case .deposit:
                return 0.7
            case .loan:
                return 1.1
            }
        }
        
        var name: String {
            switch self {
            case .deposit:
                return "예금"
            case .loan:
                return "대출"
            }
        }
    }
}
