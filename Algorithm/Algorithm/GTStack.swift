//
//  Stack.swift
//  Algorithm
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//

import Foundation
import UIKit

class Node<T>{
    let value: T
    var next: Node?
    init(value: T){
        self.value = value
    }
}

struct operators{
    let plus:String
    let minus:String
    let multiple:String
    let divide:String
}

class GTStack<T>{
    var top: Node<T>?
    
    func push(_  value: T){
        let oldTop = top
        top = Node(value: value)
        top?.next = oldTop
    }
    
    func pop() -> T?{
        let currentTop = top
        top = top?.next
        return currentTop?.value
    }
    
    func peek() -> T? {
        return top?.value
    }
}
