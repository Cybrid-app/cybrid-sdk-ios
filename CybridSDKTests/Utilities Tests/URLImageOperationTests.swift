//
//  URLImageOperationTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 16/06/22.
//

@testable import CybridSDK
import PDFKit
import XCTest

class URLImageOperationTests: XCTestCase {
  private let mockURLSession = MockURLSession()

  func testImageOperation_success() {
    // Given
    let url = URL(string: "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    XCTAssertNotNil(url)

    let bundle = Bundle.init(for: Self.self)
    let testImage = UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
    XCTAssertNotNil(testImage)

    let pdfPage = PDFPage(image: testImage!)
    let testImageData = pdfPage?.dataRepresentation
    XCTAssertNotNil(testImageData)

    // When
    let imageOperation = ImageDownloadOperation(url: url!, dataProvider: mockURLSession)
    imageOperation.start()
    mockURLSession.didFinish(with: testImageData!, response: nil, error: nil)

    // Then
    XCTAssertNotNil(imageOperation.image)
  }

  func testImageOperation_error() {
    // Given
    let url = URL(string: "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    XCTAssertNotNil(url)

    let bundle = Bundle.init(for: Self.self)
    let testImage = UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
    XCTAssertNotNil(testImage)

    let pdfPage = PDFPage(image: testImage!)
    let testImageData = pdfPage?.dataRepresentation
    XCTAssertNotNil(testImageData)

    // When
    let imageOperation = ImageDownloadOperation(url: url!, dataProvider: mockURLSession)
    imageOperation.start()
    mockURLSession.didFinish(with: testImageData!, response: nil, error: MockError.testError)

    // Then
    XCTAssertNil(imageOperation.image)
  }

  func testImageOperation_noData() {
    // Given
    let url = URL(string: "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    XCTAssertNotNil(url)

    // When
    let imageOperation = ImageDownloadOperation(url: url!, dataProvider: mockURLSession)
    imageOperation.start()
    mockURLSession.didFinish(with: nil, response: nil, error: nil)

    // Then
    XCTAssertNil(imageOperation.image)
  }

  func testImageOperation_invalidDataFormat() {
    // Given
    let url = URL(string: "https://images.cybrid.xyz/sdk/assets/pdf/color/btc.pdf")
    XCTAssertNotNil(url)

    let mockData = "MockString".data(using: .utf8)

    // When
    let imageOperation = ImageDownloadOperation(url: url!, dataProvider: mockURLSession)
    imageOperation.start()
    mockURLSession.didFinish(with: mockData, response: nil, error: nil)

    // Then
    XCTAssertNil(imageOperation.image)
  }
}
