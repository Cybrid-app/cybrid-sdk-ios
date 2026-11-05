import XCTest
import UIKit
@testable import CybridSDK

final class ResourceTests: XCTestCase {
    func testImageLoadsFromPackageBundle() {
        XCTAssertNotNil(UIImage(named: "kyc_error", in: Bundle.sdkBundle, with: nil))
        XCTAssertNotNil(getImage("cybrid"))
    }

    func testLocalizedStrings() {
        let en = CybridLocalizer(locale: Locale(identifier: "en")).localize(with: "cybrid.customer.frozen")
        let fr = CybridLocalizer(locale: Locale(identifier: "fr")).localize(with: "cybrid.customer.frozen")
        XCTAssertEqual(en, "Your account has been frozen.")
        XCTAssertEqual(fr, "Votre compte a été gelé.")
    }
}
