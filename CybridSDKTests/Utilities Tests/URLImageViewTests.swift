//
//  URLImageViewTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import XCTest

class URLImageViewTests: XCTestCase {
  private let mockURLSession = MockURLSession()
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

  func testInvalidURL() {
    let urlImage = URLImageView(urlString: "Hello World")
    urlImage?.inject(dataProvider: mockURLSession)

    XCTAssertNil(urlImage)
  }

  func testValidURL() {
    let urlImage = URLImageView(urlString: "https://images.cybrid.xyz/color/btc.svg")
    urlImage?.inject(dataProvider: mockURLSession)

    XCTAssertNotNil(urlImage)
  }

  func testPlaceholder() {
    // Given
    XCTAssertNotNil(url)
    XCTAssertNotNil(testImage)

    // When
    let urlImage = URLImageView(url: url!, placeholder: testImage!)
    urlImage.inject(dataProvider: mockURLSession)

    // Then
    XCTAssertEqual(urlImage.placeholder, testImage)
  }

  func testImageViewLoad() {
    // Given
    XCTAssertNotNil(url)
    XCTAssertNotNil(testImage)

    // When
    let urlImage = URLImageView(url: url!)
    let mockImageOperation = MockImageOperation(image: testImage!)
    urlImage
      .inject(
        operationQueue: MockOperationQueue(),
        dataProvider: mockURLSession,
        completionDispatchQueue: MockDispatchQueue(),
        imageOperationProvider: { _, _ in
          mockImageOperation
        }
      )
    urlImage.layoutSubviews()

    // Then
    XCTAssertNotNil(urlImage.image)
  }

  func testInvalidInit() {
    expectAssertionFailure(expectedMessage: "init(coder:) should never be used") {
      let urlImage = URLImageView(coder: NSCoder())
    }
  }

  func testImageLoadRetry() {
    // Given
    XCTAssertNotNil(url)
    XCTAssertNotNil(testImage)

    // When
    let urlImage = URLImageView(url: url!)
    let mockImageOperation = MockImageOperation(image: testImage!)
    urlImage
      .inject(
        operationQueue: MockOperationQueue(),
        dataProvider: mockURLSession,
        completionDispatchQueue: MockDispatchQueue(),
        imageOperationProvider: { _, _ in
          mockImageOperation
        }
      )
    XCTAssertFalse(mockImageOperation.isExecuting)
    mockImageOperation.wait()
    urlImage.layoutSubviews()
    mockImageOperation.resume()
    XCTAssertTrue(mockImageOperation.isExecuting)
    urlImage.layoutSubviews()

    // Then
    XCTAssertNotNil(urlImage.image)
  }
}
