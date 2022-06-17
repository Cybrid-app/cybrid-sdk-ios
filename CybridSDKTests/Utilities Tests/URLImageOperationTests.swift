//
//  URLImageOperationTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 16/06/22.
//

@testable import CybridSDK
import XCTest

class URLImageOperationTests: XCTestCase {
  let mockURLSession = MockURLSession()
  private var url: URL?
  private var testImage: UIImage?
  private var testImageData: Data?

  override func setUpWithError() throws {
    self.url = URL(string: "https://images.cybrid.xyz/color/btc.svg")
    let bundle = Bundle.init(for: Self.self)
    self.testImage = UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
    self.testImageData = testImage?.jpegData(compressionQuality: 1)
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    url = nil
    testImage = nil
    testImageData = nil
    try super.tearDownWithError()
  }

  func testImageOperation_success() {
    // Given
    XCTAssertNotNil(url)
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
    XCTAssertNotNil(url)
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
    XCTAssertNotNil(url)

    // When
    let imageOperation = ImageDownloadOperation(url: url!, dataProvider: mockURLSession)
    imageOperation.start()
    mockURLSession.didFinish(with: nil, response: nil, error: nil)

    // Then
    XCTAssertNil(imageOperation.image)
  }
}
