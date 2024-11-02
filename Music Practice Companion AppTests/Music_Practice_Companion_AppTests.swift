//
//  Music_Practice_Companion_AppTests.swift
//  Music Practice Companion AppTests
//
//  Created by Hayden Kua on 27/09/2020.
//

import XCTest
@testable import Music_Practice_Companion_App

class Music_Practice_Companion_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUserDetailPresenceValidationCheckReturnsCorrectBool(){
            let testCases = [(email: "email", password: "password", expected: true), (email: "", password: "", expected: false), (email: "", password: "password", expected: false)]
            
            for testCase in testCases {
                let test = UserInformationTest()
                let actual = test.checkPresence(email: testCase.email, password: testCase.password)
                XCTAssertEqual(actual, testCase.expected)
            }
        }
        
    func testEmailCheckReturnsCorrectBool(){
        let testCases = [(email: "person@bob.com", expected: true), (email: "personbob", expected: false), (email: "person@bob", expected: false)]
        
        for testCase in testCases {
            let test = UserInformationTest()
            let actual = test.checkEmail(email: testCase.email)
            XCTAssertEqual(actual, testCase.expected)
        }
    }
    
    func testPasswordLengthIsAtLeastEightChars(){
        let testCases = [(password: "1234567", expected: false), (password: "12345678", expected: true), (password: "123456789", expected: true)]
        
        for testCase in testCases {
            let user = UserInformationTest()
            let actual = user.checkPasswordLength(password: testCase.password)
            XCTAssertEqual(actual, testCase.expected)
        }
    }
    
    func testMethodGetTempoReturnsCorrectValue(){
        let testCases = [(rawValue: 2.5, expected: 150), (rawValue: 0.5, expected: 30), (rawValue: 1.0, expected: 60)]
        
        for testCase in testCases {
            let metronome = Metronome()
            let actual = Int(metronome.getTempo(rawValue: Float(testCase.rawValue)))
            XCTAssertEqual(actual, testCase.expected)
        }
    }
    
}
