//
//  Int+Extension.swift
//  TimeLeft Shape Sample
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 inDabusiness. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
    
    /// returns number of digits in Int number
    var digitCount: Int {
        get {
            return numberOfDigits(in: self)
        }
    }
    /// returns number of useful digits in Int number
    var usefulDigitCount: Int {
        get {
            var count = 0
            for digitOrder in 0..<self.digitCount {
                /// get each order digit from self
                let digit = self % (Int(truncating: pow(10, digitOrder + 1) as NSDecimalNumber))
                    / Int(truncating: pow(10, digitOrder) as NSDecimalNumber)
                if isUseful(digit) { count += 1 }
            }
            return count
        }
    }
    // private recursive method for counting digits
    private func numberOfDigits(in number: Int) -> Int {
        if number < 10 && number >= 0 || number > -10 && number < 0 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }
    // returns true if digit is useful in respect to self
    private func isUseful(_ digit: Int) -> Bool {
        return (digit != 0) && (self % digit == 0)
    }
    
    var large:Int {
        get{
            let closedRange = [25, 50, 75, 100]
            return closedRange.randomElement()!
        }
        
    }
    
    var small:Int {
        get{
            let closedRange:ClosedRange<Int> = 1...10
            return Int.random(in: closedRange)
        }
        
    }
}

