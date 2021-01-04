<img src="https://img.shields.io/badge/platforms-ios-green" /> 

**Figma** is a popular design tool used by development companies to mock up products.
This repository contains a custom UILabel to help prefectly reproduce the labels that are generated within Figma.

**FigmaLabel** is a simple UILabel-inherited class meant to help mimic Figma labels.

Download this repository to view the code in action. There are demonstrations using IB/Storyboards & programmatically created labels.
Examples on how to create attributed text is also included.


## Demonstration

Here's an example of a label rendered in Figma with the right side panel inspector displaying all the attributes needed to create such a label:

<img src="Assets/figma_example_english.png"></img>

Here's how such a label would be created programmatically:

```swift
// Label
let label = FigmaLabel()
label.font = UIFont(name: "ObjectSans-Regular", size: 15)
label.lineHeight = 18
label.textColor = UIColor(red: 0.087, green: 0.087, blue: 0.087, alpha: 1)
label.textAlignment = .left
label.numberOfLines = 0
view.addSubview(label)

// Attribution
let text = "1244 people are already enjoying this pack"
let highlight = "1244 people"

var attributes = label.attributes()

let attributedText = NSMutableAttributedString(string: text)
attributedText.addAttributes(attributes, range: text.fullRange())

if let range = text.rangeOfString(highlight) {
    attributes[.foregroundColor] = UIColor(red: 0.087, green: 0.087, blue: 0.087, alpha: 1)
    attributes[.font] = UIFont(name: "ObjectSans-Bold", size: 15)
    attributedText.addAttributes(attributes, range: range)
}

label.attributedText = attributedText

// Constraints

// *NOTE: `imagesContainerView` was created inside the storyboard & used in place of the 3 image views with faces that is inside the design!

label.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: imagesContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: imagesContainerView, attribute: .right, multiplier: 1, constant: 12).isActive = true
NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: -24).isActive = true
```

The result would be as following:

<img src="Assets/code_example.jpeg"></img>
