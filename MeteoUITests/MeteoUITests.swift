//
//  MeteoUITests.swift
//  MeteoUITests
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import XCTest

final class MeteoUITests: XCTestCase {

    func testGeneralUI() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["-UITEST"]
        app.launch()

        let mainImageElement = app.images["mainWeatherImageView"]
        mainImageElement.swipeRight()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Home"]/*[[".cells.staticTexts[\"Home\"]",".staticTexts[\"Home\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        mainImageElement.swipeRight()
        app.tables.staticTexts["Map"].tap()
        XCTAssertTrue(app.navigationBars["Favorites Map"].staticTexts["Favorites Map"].exists)
        app.navigationBars["Favorites Map"].staticTexts["Favorites Map"].swipeDown()
        XCTAssertTrue(app.images["mainWeatherImageView"].exists)
    }

    func testSecondGeneralUI() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["-UITEST"]
        app.launch()
        let mainImageElement = app.images["mainWeatherImageView"]
        mainImageElement.swipeRight()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Home"]/*[[".cells.staticTexts[\"Home\"]",".staticTexts[\"Home\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.cells["forecastCellID"].exists)
        app.cells["forecastCellID"].tap()
        XCTAssertTrue(app.navigationBars["Detailed view"].staticTexts["Detailed view"].exists)
        app.navigationBars["Detailed view"].staticTexts["Detailed view"].swipeDown()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
