

# Error View
[![CI Status](http://img.shields.io/travis/philip-bui/error-view.svg?style=flat)](https://travis-ci.org/philip-bui/error-view)
[![CodeCov](https://codecov.io/gh/philip-bui/error-view/branch/master/graph/badge.svg)](https://codecov.io/gh/philip-bui/error-view)
[![Version](https://img.shields.io/cocoapods/v/ErrorView.svg?style=flat)](http://cocoapods.org/pods/ErrorView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/ErrorView.svg?style=flat)](http://cocoapods.org/pods/ErrorView)
[![License](https://img.shields.io/cocoapods/l/ErrorView.svg?style=flat)](https://github.com/philip-bui/error-view/blob/master/LICENSE)

Error View appendable to View Controllers subviews.

- Animated in and out effects.
- Text shake effects.

## Requirements

- iOS 9.0+
- Xcode 10.3+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Error View into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'ErrorView'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Error View into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "philip-bui/error-view"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Error View does support its use on supported platforms.

Once you have your Swift package set up, adding Error View as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/philip-bui/error-view.git", from: "1.0.0"))
]
```

## Usage

```swift
import ErrorView

// AppDelegate.swift - Modify global defaults.
ErrorView.backgroundColor = UIColor.orange
ErrorView.font = UIFont.boldSystemFont(ofSize: 14.5)
ErrorView.textColor = UIFont.white

// ViewController.swift - Customize own error views
private weak var errorView: ErrorView?

private func textViewDidBeginEditing(_ textView: UITextView) {
	errorView?.dismiss()	
}

private func textViewDidEndEditing(_ textView: UITextView) {
	guard true else {
		errorView = ErrorView(addTo: self, text: "Invalid text")
		return
	}
}
```

## License

Error View is available under the MIT license. [See LICENSE](https://github.com/philip-bui/error-view/blob/master/LICENSE) for details.
