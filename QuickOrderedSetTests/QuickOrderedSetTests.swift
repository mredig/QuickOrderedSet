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
		var sideArray = [Int]()

		for index in 1...10 {
			testingOrderedSet.append(index)
			sideArray.append(index)
		}
		return (testingOrderedSet, sideArray)
	}

	func testAppendNew() {
		var (testingOrderedSet, sideArray) = defaultValues()

		testingOrderedSet.append(11)
		sideArray.append(11)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}

	}

	func testAppendExisting() {
		var (testingOrderedSet, sideArray) = defaultValues()

		// append existing
		testingOrderedSet.append(1)
		sideArray.append(1)
		sideArray.removeFirst()
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}

	}

	func testSetExistingMoveDown() {
		var (testingOrderedSet, sideArray) = defaultValues()

		// set existing, moving down
		testingOrderedSet[5] = 10
		sideArray.remove(at: 9)
		sideArray.remove(at: 5)
		sideArray.insert(10, at: 5)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetExistingMoveUp() {
		var (testingOrderedSet, sideArray) = defaultValues()

		// set existing, moving up
		testingOrderedSet[4] = 1
		sideArray.remove(at: 4)
		sideArray.insert(1, at: 4)
		sideArray.remove(at: 0)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count,
				  "\(testingOrderedSet.contents.count) and \( testingOrderedSet.sequencedContents.count)")
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetNew() {
		var (testingOrderedSet, sideArray) = defaultValues()

		//set new
		testingOrderedSet[4] = 15
		sideArray[4] = 15
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetReplaceWithSame() {
		var (testingOrderedSet, sideArray) = defaultValues()
		//		var (originalSet, _) = defaultValues()

		testingOrderedSet[0] = 1
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetEndValue() {
		var (testingOrderedSet, sideArray) = defaultValues()

		let endValue = sideArray.count - 1
		testingOrderedSet[endValue] = 15
		sideArray[endValue] = 15
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testRemoving() {
		var (testingOrderedSet, sideArray) = defaultValues()

		// removing inside
		testingOrderedSet.remove(at: 8)
		sideArray.remove(at: 8)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(sideArray.count == testingOrderedSet.sequencedContents.count)
		for index in sideArray.indices {
			XCTAssert(sideArray[index] == testingOrderedSet[index], "\(sideArray) != \(testingOrderedSet)")
		}

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testBasic() {
		let (testingOrderedSet, _) = defaultValues()

		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		//should be run after every edit
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}
}
