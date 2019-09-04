//
//  TimeInterval+Extension.swift
//  TimeLeft Shape Sample
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 inDabusiness. All rights reserved.
//

import Foundation

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}

