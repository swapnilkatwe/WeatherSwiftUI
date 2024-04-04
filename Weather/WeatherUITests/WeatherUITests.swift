//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by SK on 25/11/23.
//

import XCTest

class WeatherUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testHomeScreen() throws {
        let textField = app.textFields["cityTextField"]
        XCTAssertTrue(textField.exists)
        
        textField.tap()
        textField.typeText("Oslo")
        
        let button = app.buttons["searchButton"]
        XCTAssertTrue(button.exists)
        
        button.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
