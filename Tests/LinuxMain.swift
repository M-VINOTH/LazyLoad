import XCTest

import LazyLoadTests

var tests = [XCTestCaseEntry]()
tests += LazyLoadTests.allTests()
XCTMain(tests)
