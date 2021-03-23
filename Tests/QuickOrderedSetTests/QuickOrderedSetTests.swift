//
//  QuickOrderedSetTests.swift
//  QuickOrderedSetTests
//
//  Created by Michael Redig on 5/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
//swiftlint:disable type_body_length file_length

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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
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
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testBasic() {
		let (testingOrderedSet, truthArray) = defaultValues()

		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testCodableFromSet() throws {
		let (testingOrderedSet, truthArray) = defaultValues()

		let encoder = JSONEncoder()
		let dataFromSet = try encoder.encode(testingOrderedSet)

		let str = String(data: dataFromSet, encoding: .utf8)
		print(str ?? "")

		let decoder = JSONDecoder()
		let decodedSet = try decoder.decode(QuickOrderedSet<Int>.self, from: dataFromSet)

		XCTAssert(decodedSet.contents.count == decodedSet.sequencedContents.count)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(Array(decodedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testCodableFromArray() throws {
		let (testingOrderedSet, truthArray) = defaultValues()

		let encoder = JSONEncoder()
		let dataFromArray = try encoder.encode(truthArray)

		let str = String(data: dataFromArray, encoding: .utf8)
		print(str ?? "")

		let decoder = JSONDecoder()
		let decodedSet = try decoder.decode(QuickOrderedSet<Int>.self, from: dataFromArray)

		XCTAssert(decodedSet.contents.count == decodedSet.sequencedContents.count)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)
		XCTAssert(Array(decodedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testInsertNewElementAtIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let newValue = 15
		testingOrderedSet.insert(newValue, at: 1)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray.insert(newValue, at: 1)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testInsertExistingElementAtIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let existingValue = 5
		testingOrderedSet.insert(existingValue, at: 1)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testReplaceNewElementAtIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let newValue = 15
		testingOrderedSet.replace(atIndex: 1, withElement: newValue)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray[1] = newValue
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testReplaceExistingElementAtIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let existingValue = 5
		testingOrderedSet.replace(atIndex: 1, withElement: existingValue)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testReplaceExistingOldElementWithNewElement() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let existingOld = 2
		let newValue = 15
		testingOrderedSet.replace(existingOld, withNewElement: newValue)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		let truthIndex = truthArray.firstIndex(of: existingOld)!
		truthArray[truthIndex] = newValue
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testReplaceNonExistingOldElementWithNewElement() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let nonExistingOld = 16
		let newValue = 15
		testingOrderedSet.replace(nonExistingOld, withNewElement: newValue)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testReplaceExistingOldElementWithExistingElement() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let existingOld = 2
		let existingValue = 5
		testingOrderedSet.replace(existingOld, withNewElement: existingValue)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testReplaceNonExistingOldElementWithExistingElement() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let nonExistingOld = 16
		let existingValue = 15
		testingOrderedSet.replace(nonExistingOld, withNewElement: existingValue)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetNewElementAtInsideIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let newValue = 15
		testingOrderedSet.set(newValue, at: 1)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray[1] = newValue
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetNewElementAtEnd() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let newValue = 15
		testingOrderedSet.set(newValue, at: testingOrderedSet.count)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		truthArray.append(newValue)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetExistingElementAtInsideIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let existingValue = 5
		testingOrderedSet.set(existingValue, at: 1)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testSetExistingElementAtEnd() {
		var (testingOrderedSet, truthArray) = defaultValues()

		let existingValue = 5
		testingOrderedSet.set(existingValue, at: testingOrderedSet.count)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testExchangeElementsViaIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let indexA = 3
		let indexB = 8
		testingOrderedSet.exchange(elementAt: indexA, withElementAt: indexB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		truthArray.swapAt(indexA, indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testExchangeElements() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let valueA = 3
		let valueB = 8
		testingOrderedSet.exchange(valueA, with: valueB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let indexA = truthArray.firstIndex(of: valueA)!
		let indexB = truthArray.firstIndex(of: valueB)!
		truthArray.swapAt(indexA, indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testMoveIndexToEnd() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let indexA = 0
		let indexB = testingOrderedSet.count - 1
		testingOrderedSet.move(elementAtIndex: indexA, to: indexB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let movedValue = truthArray[indexA]
		truthArray.remove(at: indexA)
		truthArray.insert(movedValue, at: indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testMoveIndexToStart() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let indexA = testingOrderedSet.count - 1
		let indexB = 0
		testingOrderedSet.move(elementAtIndex: indexA, to: indexB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let movedValue = truthArray[indexA]
		truthArray.remove(at: indexA)
		truthArray.insert(movedValue, at: indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testMoveIndexUpInMiddle() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let indexA = 3
		let indexB = 8
		testingOrderedSet.move(elementAtIndex: indexA, to: indexB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let movedValue = truthArray[indexA]
		truthArray.remove(at: indexA)
		truthArray.insert(movedValue, at: indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testMoveIndexDownInMiddle() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let indexA = 8
		let indexB = 3
		testingOrderedSet.move(elementAtIndex: indexA, to: indexB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let movedValue = truthArray[indexA]
		truthArray.remove(at: indexA)
		truthArray.insert(movedValue, at: indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testMoveToSameIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let indexA = 5
		let indexB = 5
		testingOrderedSet.move(elementAtIndex: indexA, to: indexB)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let movedValue = truthArray[indexA]
		truthArray.remove(at: indexA)
		truthArray.insert(movedValue, at: indexB)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}

	func testMoveElementToIndex() {
		var (testingOrderedSet, truthArray) = defaultValues()

		// run ordered set function, then test basic counts of its contents
		let value = 5
		let newIndex = 0
		testingOrderedSet.move(value, to: newIndex)
		XCTAssert(testingOrderedSet.contents.count == testingOrderedSet.sequencedContents.count)

		// replicate what the function should do on the truthArray, then test that they match
		let oldIndex = truthArray.firstIndex(of: value)!
		truthArray.remove(at: oldIndex)
		truthArray.insert(value, at: newIndex)
		XCTAssert(Array(testingOrderedSet.sequencedContents) == truthArray)

		//should be run after every edit
		XCTAssert(testingOrderedSet.sequencedContents.count == testingOrderedSet.contents.count)
		for (index, element) in testingOrderedSet.sequencedContents.enumerated() {
			XCTAssert(testingOrderedSet.contents[element] == index, "\(testingOrderedSet.contents)")
		}
	}
}
