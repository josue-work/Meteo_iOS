//
//  MeteoTests.swift
//  MeteoTests
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import XCTest
@testable import Meteo

final class MeteoTests: XCTestCase {

    func testObfuscation() throws {
        let defuscatedString = Constants.testStringKey
        var expectedString = "This is to test my obfuscated string is decoded nicely"
        XCTAssertEqual(defuscatedString, expectedString)
    }
}
