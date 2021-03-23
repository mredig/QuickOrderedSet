//
//  MyOrderedSet.swift
//  Reading List
//
//  Created by Michael Redig on 4/30/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
// swiftlint:disable

import Foundation

public struct QuickOrderedSet<Type: Hashable> {
	private(set) var sequencedContents: ContiguousArray<Type>
	private(set) var contents: [Type: Int]

	public init() {
		sequencedContents = []
		contents = [Type: Int]()
	}

	public init(_ array: [Type]) {
		self.init()
		array.forEach { append($0) }
	}

	/// Returns the index of the element, if it's included in the ordered set. Nil otherwise.
	public func index(of element: Type) -> Int? {
		guard contains(element) else { return nil }
		guard let proposedIndex = contents[element] else {
			fatalError("Element not a member, despite just being confirmed as one.")
		}
		guard
			element == sequencedContents[proposedIndex]
		else {
			print("index incorrectly cached - retrieving correct index")
			if let index = sequencedContents.firstIndex(of: element) {
				return index
			}
			return nil
		}
		return proposedIndex
	}

	/// Appends a new element *if it doesn't already exist in the ordered set*
	public mutating func append(_ element: Type) {
		if !contains(element) {
			// order matters here
			contents[element] = sequencedContents.count
			sequencedContents.append(element)
		}
	}

	/// Removes an element if it's present in the ordered set
	public mutating func remove(_ element: Type) {
		guard
			contains(element),
			let index = sequencedContents.firstIndex(of: element)
		else { return }

		remove(at: index)
	}

	/// Removes the element at the requested index. Crashes if index is out of bounds, however.
	public mutating func remove(at index: Int) {
		precondition(sequencedContents.count > index, "Index '\(index)' out of bounds")
		let objectAtIndex = sequencedContents[index]
		contents.removeValue(forKey: objectAtIndex)
		sequencedContents.remove(at: index)
		updateIndicies(in: index..<sequencedContents.count)
	}

	/// Returns a Bool determining if an element is present in the ordered set
	public func contains(_ element: Type) -> Bool {
		return contents[element] != nil
	}

	/**
	Counters typical Ordered Set behavior:
		* if the value already exists in the array, it does nothing...
			* (which is normal behavior)
		* BUT if the value already exists and is at the specified index, it replaces the existing value with the new one.
			* This is counter the normal behavior.
			* this is done for my own personal project where I'm using a counter object that consists of a value and a counter;
				the counter is not evaluated in the hash, but when incrementing the counter, it'll need to replace the old value.
	*/
	public subscript(index: Int) -> Type {
		get {
			return sequencedContents[index]
		}
		set {
			if contains(newValue) {
				if sequencedContents[index] == newValue {
					sequencedContents[index] = newValue
					contents.removeValue(forKey: newValue)
					contents[newValue] = index
				}
			} else {
				let oldValue = sequencedContents[index]
				sequencedContents[index] = newValue
				contents.removeValue(forKey: oldValue)
				contents[newValue] = index
			}
		}
	}

	/// Inserts a new element at the index specified if it's not already a member
	public mutating func insert(_ newElement: Type, at index: Int) {
		if !contains(newElement) {
			sequencedContents.insert(newElement, at: index)
			contents[newElement] = index
			updateIndicies(in: index..<sequencedContents.count)
		}
	}

	/// Replaces element at specified index with provided element, given the provided element is not already a memeber
	public mutating func replace(atIndex index: Int, withElement element: Type) {
		guard !contains(element) else { return }
		let oldElement = sequencedContents[index]
		sequencedContents[index] = element
		contents.removeValue(forKey: oldElement)
		contents[element] = index
	}

	/**
	Replaces a given element with a new element. Will only proceed if both the old
	element is already a member and the new element is not.
	*/
	public mutating func replace(_ oldElement: Type, withNewElement newElement: Type) {
		guard
			contains(newElement) == false,
			let index = index(of: oldElement)
		else { return }

		replace(atIndex: index, withElement: newElement)
	}

	/// Appends or replaces the element at the specified index, if it isn't already a member.
	public mutating func set(_ element: Type, at index: Int) {
		guard !contains(element) else { return }
		if index == sequencedContents.count {
			//append
			append(element)
		} else {
			//replace
			replace(atIndex: index, withElement: element)
		}
	}

	/// Exchanges element at the specified index with the element at the other index
	public mutating func exchange(elementAt oldIndex: Int, withElementAt newIndex: Int) {
		precondition(oldIndex < count)
		precondition(newIndex < count)
		sequencedContents.swapAt(oldIndex, newIndex)
		contents[sequencedContents[oldIndex]] = oldIndex
		contents[sequencedContents[newIndex]] = newIndex
	}

	/// Exchanges the first element with the second element in the index, if both elements are members
	public mutating func exchange(_ elementA: Type, with elementB: Type) {
		guard
			contains(elementA), contains(elementB),
			let indexA = index(of: elementA),
			let indexB = index(of: elementB)
		else { return }

		exchange(elementAt: indexA, withElementAt: indexB)
	}

	/// Moves the element from one index to another
	public mutating func move(elementAtIndex oldIndex: Int, to newIndex: Int) {
		precondition(oldIndex < count)
		precondition(newIndex < count)

		let iterator: Int
		if newIndex < oldIndex {
			iterator = -1
		} else {
			iterator = 1
		}

		for currentIndex in stride(from: oldIndex, to: newIndex, by: iterator) {
			exchange(elementAt: currentIndex, withElementAt: currentIndex + iterator)
		}
	}

	/// Moves a given element to a new index, if it's a member
	public mutating func move(_ element: Type, to index: Int) {
		guard
			contains(element),
			let oldIndex = self.index(of: element)
		else { return }

		move(elementAtIndex: oldIndex, to: index)
	}

	public var count: Int { sequencedContents.count }

	public var isEmpty: Bool { sequencedContents.isEmpty }

	enum CodingKeys: String, CodingKey {
		case sequencedContents
		case contents
	}
}

// MARK: - Collection
extension QuickOrderedSet: Collection {
	public func index(after i: Int) -> Int {
		return sequencedContents.index(after: i)
	}
}

// MARK: - Random Access Collection
extension QuickOrderedSet: RandomAccessCollection {
	public var startIndex: Int { 0 }

	public var endIndex: Int { sequencedContents.count }
}

// MARK: - Codable
extension QuickOrderedSet: Codable where Type: Codable {

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(sequencedContents, forKey: CodingKeys.sequencedContents)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let tempContents = try container.decode([Type].self, forKey: .sequencedContents)
		self.init(tempContents)
		guard contents.count == sequencedContents.count else { throw QuickOrderedSetError.decodedArrayNotValidForSet }
	}

	enum QuickOrderedSetError: Error {
		case decodedArrayNotValidForSet
	}
}

// MARK: - Custom String Convertible
extension QuickOrderedSet: CustomStringConvertible {
	public var description: String {
		sequencedContents.description
	}
}

// MARK: - Custom Debug String Convertible
extension QuickOrderedSet: CustomDebugStringConvertible {
	public var debugDescription: String {
		sequencedContents.debugDescription
	}
}

// MARK: - Expressible by Array Literal
extension QuickOrderedSet: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Type...) {
		self.init(elements)
	}
}

// MARK: - Index Caching
extension QuickOrderedSet {
	private mutating func updateIndicies(in range: Range<Int>) {
		for index in range {
			contents[sequencedContents[index]] = index
		}
	}
}
