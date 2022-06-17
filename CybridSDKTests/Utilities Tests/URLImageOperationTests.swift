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

  func testImageOperation() {
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

    // Image Operation
    let imageOperation = ImageDownloadOperation(url: url!, dataProvider: mockURLSession)
    imageOperation.start()

    mockURLSession.success(with: imageData!)
    XCTAssertNotNil(imageOperation.image)
  }
}
