//
//  URLImageViewTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import XCTest

class URLImageViewTests: XCTestCase {
  let mockURLSession = MockURLSession()

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
    // URL
    let url = URL(string: "https://images.cybrid.xyz/color/btc.svg")
    XCTAssertNotNil(url)

    // Placeholder
    let bundle = Bundle.init(for: Self.self)
    let placeholder: UIImage? = UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
    XCTAssertNotNil(placeholder)

    // URLImage
    let urlImage = URLImageView(url: url!, placeholder: placeholder)
    urlImage.inject(dataProvider: mockURLSession)
    XCTAssertEqual(urlImage.placeholder, placeholder)
  }

  func testImageViewLoad() {
    // URL
    let url = URL(string: "https://images.cybrid.xyz/color/btc.svg")
    XCTAssertNotNil(url)

    // Local Image
    let bundle = Bundle.init(for: Self.self)
    let image: UIImage? = UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
    XCTAssertNotNil(image)

    // Image Data
    let imageData = image!.jpegData(compressionQuality: 1)
    XCTAssertNotNil(imageData)

    // URLImage
    let urlImage = URLImageView(url: url!)
    let mockImageOperation = MockImageOperation(image: image)
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

    XCTAssertNotNil(urlImage.image)
  }

  func testInvalidInit() {
    expectAssertionFailure(expectedMessage: "init(coder:) should never be used") {
      let urlImage = URLImageView(coder: NSCoder())
    }
  }
}
