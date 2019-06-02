//
//  QuickOrderedSetTests.swift
//  QuickOrderedSetTests
//
//  Created by Michael Redig on 5/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import XCTest
@testable import QuickOrderedSet

class QuickOrderedSetTests: XCTestCase {

	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func defaultValues() -> (set: QuickOrderedSet<Int>, array: [Int]) {
		var testingOrderedSet = QuickOrderedSet<Int>()
		var truthArray = [Int]()

		for index in 1...10 {
			testingOrderedSet.append(index)
			truthArray.append(index)
		}
		return (testingOrderedSet, truthArray)
	}

	func testAppendNew() {
		var (testingOrderedSet, truthArray) = defaultValues()

		testingOrderedSet.append(11)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray.append(11)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testAppendExisting() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// append existing (should be no change)
		testingOrderedSet.append(1)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testSetExisting() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// set existing (should be no change)
		testingOrderedSet[5] = 10
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testSetNew() {
		var (testingOrderedSet, truthArray) = defaultValues()

		//set new
		testingOrderedSet[4] = 15
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray[4] = 15
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testSetReplaceWithSame() {
		var (testingOrderedSet, truthArray) = defaultValues()

		testingOrderedSet[0] = 1
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray[0] = 1
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testSetEndValue() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let endIndex = testingOrderedSet.count - 1
		testingOrderedSet[endIndex] = 15
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray[endIndex] = 15
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testRemoving() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// removing inside
		testingOrderedSet.remove(at: 8)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray.remove(at: 8)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testBasic() {
		let (testingOrderedSet, truthArray) = defaultValues()

		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}
	}

	func testCodable() {
		let (testingOrderedSet, truthArray) = defaultValues()

		let encoder = JSONEncoder()
		var data = Data()
		do {
			data = try encoder.encode(testingOrderedSet)
		} catch {
			XCTAssert(false, "failed encoding: \(error)")
		}

		let str = String(data: data, encoding: .utf8)
		print(str ?? "")

		let decoder = JSONDecoder()
		var wrappedDecodedSet: QuickOrderedSet<Int>?
		do {
			wrappedDecodedSet = try decoder.decode(QuickOrderedSet<Int>.self, from: data)
		} catch {
			XCTAssert(false, "failed decoding: \(error)")
		}

		guard let decodedSet = wrappedDecodedSet else { XCTAssert(false); return }
		XCTAssert(decodedSet.contents.count == decodedSet.sequencedContents.count)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(Array(decodedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for element in testingOrderedSet.sequencedContents {
			XCTAssert(testingOrderedSet.contents.contains(element), "\(testingOrderedSet.contents)")
		}

	}
}
