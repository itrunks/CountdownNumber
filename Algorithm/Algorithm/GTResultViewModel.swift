//
//  CountdownViewModel.swift
//  Algorithm
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//

import Foundation


protocol ResultDelegate:NSObjectProtocol {
    func resultWithCompeletion(_ value:Result, midNumber:Int)
}


class GTResultViewModel{
    
    weak var delegate:ResultDelegate?
    
    func getResult(numbers:[Int], midNumber:Int, target:Int){
        print("nnnn = \(target)")
        guard let result:Result = self.getOperations(numbers: numbers, midNumber: midNumber, target: target) else { return  }
        if (result.success ?? false) {
            print("\(midNumber)" + result.output!);
            self.delegate?.resultWithCompeletion(result, midNumber: midNumber)
        }
        
    }
    
    
    private func  getOperations(numbers:[Int], midNumber:Int, target:Int) -> Result
    {
        //
        var midResult = Result()
        if (midNumber == target) {
            midResult.success = true;
            midResult.output = " ";
            return midResult;
        }
        
        for number in numbers {
            var newList:[Int] = numbers
            //newList.append(number)
            newList = newList.filter{$0 != number}
            if (newList.isEmpty) {
                if (midNumber - number == target) {
                    midResult.success = true;
                    midResult.output = "-" + "\(number)"
                    return midResult;
                }
                if (midNumber + number == target) {
                    midResult.success = true;
                    midResult.output = "+" + "\(number)"
                    return midResult;
                }
                if (midNumber * number == target) {
                    midResult.success = true;
                    midResult.output = "*" + "\(number)"
                    return midResult;
                }
                if (midNumber / number == target) {
                    midResult.success = true;
                    midResult.output = "/" + "\(number)"
                    return midResult;
                }
                midResult.success = false;
                midResult.output = "f" + "\(number)"
                return midResult;
            } else {
                midResult = getOperations(numbers: newList, midNumber: midNumber - number, target: target);
                if (midResult.success ?? false) {
                    let subtract = "\(number)" + midResult.output!
                    midResult.output = "-" + "\(subtract)"
                    return midResult;
                }
                midResult = getOperations(numbers: newList, midNumber: midNumber + number, target: target);
                if (midResult.success ?? false) {
                    let add = "\(number)" + midResult.output!
                    midResult.output = "+" + add
                    return midResult;
                }
                midResult = getOperations(numbers: newList, midNumber: midNumber * number, target: target);
                if (midResult.success ?? false) {
                    let multiple = "\(number)" + midResult.output!
                    midResult.output = "*" + multiple
                    return midResult;
                }
                midResult = getOperations(numbers: newList, midNumber: midNumber / number, target: target);
                if (midResult.success ?? false) {
                    let divide = "\(number)" + midResult.output!
                    midResult.output = "/" + divide
                    return midResult
                }
            }
            
        }
        return midResult;
    }
    
}

class Result
{
    
    var output:String?
    var success:Bool?
}
