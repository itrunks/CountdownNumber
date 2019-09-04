//
//  DataSource.swift
//  Algorithm
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//

import Foundation
import UIKit

protocol DataSourceDelegate {
    func arrayResult(selectdigits:Int)
}

class GTDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var delegate:DataSourceDelegate?
    let largeNumber = [25, 50, 75, 100]
    let smallNumber:[Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var segmentedControl: UISegmentedControl?

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            return self.largeNumber.count
        }else{
            return smallNumber.count
        }
    }
    
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if self.segmentedControl?.selectedSegmentIndex == 0 {
        return "\(self.largeNumber[row])"
    }else{
        return "\(smallNumber[row])"
    }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            self.delegate?.arrayResult(selectdigits: largeNumber[row])
        }else{
            self.delegate?.arrayResult(selectdigits: smallNumber[row])
        }
    }
    
    // Data source properties, initializer and methods here...
    
}
