# QuickOrderedSet

This framework is a basic Ordered Set for Swift. It was heavily inspired by [Weebly's Ordered Set](https://github.com/Weebly/OrderedSet), but that one crashed unexpectedly on certain occasions.

There are definitely some features this is missing, but it generally works and doesn't crash!

("quick" is a synonym for "swift")

### installation

#### Swift Package Manager

```swift
...
dependencies: [
	.package(url: "https://github.com/mredig/QuickOrderedSet.git", .upToNextMinor(from: "0.5.0"))
],
targets: [
	.target(
		name: "YourTarget",
		dependencies: ["QuickOrderedSet"]),
]
...
```
