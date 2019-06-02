//
//  MyOrderedSet.swift
//  Reading List
//
//  Created by Michael Redig on 4/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//
// swiftlint:disable todo

import Foundation

public struct QuickOrderedSet<Type: Codable & Hashable> {
	private(set) var sequencedContents: ContiguousArray<Type>
	private(set) var contents: Set<Type>

	init() {
		sequencedContents = []
		contents = Set<Type>()
	}

	/// Returns the index of the element, if it's included in the ordered set. Nil otherwise.
	func index(of object: Type) -> Int? {
		if let index = sequencedContents.firstIndex(of: object) {
			return index
		}
		return nil
	}

	/// Appends a new element *if it doesn't already exist in the ordered set*
	mutating func append(_ element: Type) {
		if !contents.contains(element) {
			contents.insert(element)
			sequencedContents.append(element)
		}
	}

	/// Removes an element if it's present in the ordered set
	mutating func remove(_ element: Type) {
		guard contents.contains(element),
			let index = sequencedContents.firstIndex(of: element) else { return }
		remove(at: index)
	}

	/// Removes the element at the requested index. Crashes if index is out of bounds, however.
	mutating func remove(at index: Int) {
		precondition(sequencedContents.count > index, "Index '\(index)' out of bounds")
		let objectAtIndex = sequencedContents[index]
		contents.remove(objectAtIndex)
		sequencedContents.remove(at: index)
	}

	/// Returns a Bool determining if an element is present in the ordered set
	func contains(_ element: Type) -> Bool {
		return contents.contains(element)
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
			if contents.contains(newValue) {
				if sequencedContents[index] == newValue {
					sequencedContents[index] = newValue
					contents.remove(sequencedContents[index])
					contents.insert(newValue)
				}
			} else {
				let oldValue = sequencedContents[index]
				sequencedContents[index] = newValue
				contents.insert(newValue)
				contents.remove(oldValue)
			}
		}
	}

	//TODO: Insert at
	//TODO: replace at
	//TODO: replace element
	//TODO: set at
	//TODO: move to index
	//TODO: exchange at index with index
	public var count: Int {
		return sequencedContents.count
	}

	public var isEmpty: Bool {
		return sequencedContents.isEmpty
	}

	enum CodingKeys: String, CodingKey {
		case sequencedContents
		case contents
	}
}

extension QuickOrderedSet: RandomAccessCollection {
	public var startIndex: Int {
		return 0
	}

	public var endIndex: Int {
		return sequencedContents.count
	}
}

extension QuickOrderedSet: Codable {

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(sequencedContents, forKey: CodingKeys.sequencedContents)

	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let tempContents = try container.decode([Type].self, forKey: .sequencedContents)
		sequencedContents = ContiguousArray(tempContents)
		contents = Set(sequencedContents)
		precondition(contents.count == sequencedContents.count, "Decoded value not valid set")
	}
}

extension QuickOrderedSet: CustomStringConvertible {
	public var description: String {
		return sequencedContents.description
	}
}
