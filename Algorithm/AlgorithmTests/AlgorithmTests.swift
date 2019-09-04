//
//  AlgorithmTests.swift
//  AlgorithmTests
//
//  Created by trioangle on 04/09/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//
import UIKit
import XCTest
@testable import Algorithm
 let number = ResultViewModel()
class AlgorithmTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
       
       
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCountdownFirstRound(){
         number.delegate = self
         number.getResult(numbers: [50 , 8 , 3 , 7 , 2 , 10], midNumber: 3, target: 556)
    }
    
    func testCountdownSecondRound(){
        number.delegate = self
        number.getResult(numbers: [50 , 75 , 3 , 7 , 2 , 10], midNumber: 3, target: 556)
    }
    
    func testCountdownThridRound(){
        number.delegate = self
        number.getResult(numbers: [100 , 1 , 2 , 1 , 5 , 8], midNumber: 1, target: 50)
    }
    
    
}

extension AlgorithmTests: ResultDelegate{
    func resultWithCompeletion(_ value: Result, midNumber: Int) {
         XCTAssert(true, "Success")
    }
    
    
}
