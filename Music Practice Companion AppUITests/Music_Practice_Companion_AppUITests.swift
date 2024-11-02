//
//  Music_Practice_Companion_AppUITests.swift
//  Music Practice Companion AppUITests
//
//  Created by Hayden Kua on 27/09/2020.
//

import XCTest

class Music_Practice_Companion_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testWhenLoginIsTappedWithEmpyFieldsErrorMessageAppears() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Login"].tap()

        XCTAssert(app.alerts.element.staticTexts["Please fill in both fields"].exists)
        XCTAssertEqual(app.alerts.element.label, "Presence Error")
    }
    
    func testWhenLoginIsTappedIncorrectEmailErrorMessageAppears() {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["Enter an email"].tap()
        app/*@START_MENU_TOKEN@*/.keys["x"]/*[[".keyboards.keys[\"x\"]",".keys[\"x\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.secureTextFields["Enter a password"].tap()
        app/*@START_MENU_TOKEN@*/.keys["x"]/*[[".keyboards.keys[\"x\"]",".keys[\"x\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Login"].tap()

        XCTAssert(app.alerts.element.staticTexts["Please enter a valid email"].exists)
        XCTAssertEqual(app.alerts.element.label, "Email Error")
    }
    
    func testWhenLoginIsTappedInvalidPasswordErrorMessageAppears() {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["Enter an email"].tap()
        
        app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.secureTextFields["Enter a password"].tap()
        app/*@START_MENU_TOKEN@*/.keys["x"]/*[[".keyboards.keys[\"x\"]",".keys[\"x\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Login"].tap()

        XCTAssert(app.alerts.element.staticTexts["Please enter a password that is at least 8 characters long"].exists)
        XCTAssertEqual(app.alerts.element.label, "Password Error")
    }
    
    func testWhenLoginIsTappedWithInvalidCredentialsErrorMessageAppears() {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["Enter an email"].tap()
        
        app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.secureTextFields["Enter a password"].tap()
        
        app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["4"]/*[[".keyboards.keys[\"4\"]",".keys[\"4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["6"]/*[[".keyboards.keys[\"6\"]",".keys[\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["7"]/*[[".keyboards.keys[\"7\"]",".keys[\"7\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["8"]/*[[".keyboards.keys[\"8\"]",".keys[\"8\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["9"]/*[[".keyboards.keys[\"9\"]",".keys[\"9\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Login"].tap()

        XCTAssert(app.alerts.element.staticTexts["Invalid email or password"].exists)
        XCTAssertEqual(app.alerts.element.label, "Login Error")
    }
    
}

