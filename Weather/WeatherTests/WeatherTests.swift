//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by SK on 25/11/23.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

    var viewModel: WeatherViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = WeatherViewModel(networkManager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    // Mock api test
    func testGetWeatherForCity() {
        viewModel.getWeatherForCity(city: "", for: URL(string: ""), queryParam: [])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
