//
//  MockCustomerQueue.swift
//  BankManagerConsoleTest
//
//  Created by kyungmin, Max on 2023/07/10.

import XCTest

struct MockCustomerQueue<Element>: QueueType {
    var linkedList: LinkedList<Element> = LinkedList<Element>()
    
    var headNode: Node<Element>? {
        return linkedList.firstNode
    }
    
    var tailNode: Node<Element>? {
        return linkedList.lastNode
    }

    mutating func enqueue(_ value: Element) {
        linkedList.append(value)
    }
    
    @discardableResult
    mutating func dequeue() -> Element? {
        return linkedList.pop()
    }
    
    mutating func clear() {
        linkedList.removeAll()
    }
    
    func peek() -> Element? {
        return linkedList.peek()
    }
    
    func isEmpty() -> Bool {
        return linkedList.isEmpty()
    }
}
