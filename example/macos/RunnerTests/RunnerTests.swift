import FlutterMacOS
import Cocoa
import XCTest

final class RunnerTests: XCTestCase {

  func testFlutterViewControllerCanBeCreated() {
    XCTAssertNotNil(FlutterViewController())
  }

}
