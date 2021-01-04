//
//  TextView.swift
//
//  Created by Nick Ignatenko on 2021-01-04.
//

import UIKit

class TextView: UITextView {
    
    /*
     Distance between each character.
     Расстояние между символами.
     */
    var characterSpacing: CGFloat?
    
    var lineSpacing: CGFloat?
    
    /*
     Distance between paragraphs.
     Расстояние после переноса.
     */
    var paragraphSpacing: CGFloat?
    
    /*
     Single line height.
     Высота строки.
     */
    var lineHeight: CGFloat {
        set {
            _linesHeight = newValue
        }
        get {
            return _lineHeight ?? 0
        }
    }
    
    var accentText: String?
    
    var accentTextColor: UIColor?
    
    private var _linesHeight: CGFloat?
    private var _lineHeight: CGFloat?
    private var _hyphenWidth: CGFloat?
    
    override var text: String? {
        didSet {
            let copy = text
            setupText(" ")
            
            let size = lineSize()
            _hyphenWidth = size.width
            _lineHeight = size.height

            setupText(copy)
        }
    }
    
    // MARK: - Functions
    
    func empty() -> Bool {
        return !(text != nil && text!.count > 0)
    }
    
    func width() -> CGFloat {
        return size(forWidth: CGFloat(MAXFLOAT)).width
    }
    
    func height() -> CGFloat {
        return height(forWidth: frame.width)
    }
    
    func height(forWidth width: CGFloat) -> CGFloat {
        return size(forWidth: width).height
    }
    
    func copyTextView() -> TextView {
        let textView = TextView()
        textView.font = font
        textView.textColor = textColor
        textView.textAlignment = textAlignment
        textView.characterSpacing = characterSpacing
        textView.lineSpacing = lineSpacing
        textView._linesHeight = _linesHeight
        textView.paragraphSpacing = paragraphSpacing
        textView.text = text
        textView.frame = frame
        return textView
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let maxSize = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
        return sizeThatFits(maxSize)
    }
    
    func attributes() -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()
        
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        if let textColor = textColor {
            attributes[NSAttributedString.Key.foregroundColor] = textColor
        }
        if let chapterSpacing = characterSpacing {
            attributes[NSAttributedString.Key.kern] = chapterSpacing
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        
        if let linesHeight = _linesHeight {
            style.minimumLineHeight = linesHeight - 0.01
            style.maximumLineHeight = linesHeight + 0.01
        }
        if let lineSpacing = lineSpacing {
            style.lineSpacing = lineSpacing
        }
        if let paragraphSpacing = paragraphSpacing {
            style.paragraphSpacing = paragraphSpacing
        }
        attributes[NSAttributedString.Key.paragraphStyle] = style
        return attributes
    }
    
    func calculateLines(forText text: String?, range: NSRange, results: @escaping (_ rect: CGRect) -> Void) {
        let range2 = correct(range: range, forText: text)
        
        let words = text?.substring(with: range2).components(separatedBy: " ")
        var loc = range2.location
        
        var line = CGRect.zero
        for word in words ?? [] {
            var string = word.replacingOccurrences(of: "-", with: "-\u{00AD}")
            string = string.replacingOccurrences(of: "\n", with: "\u{00AD}\n")
            let components = string.components(separatedBy: "\u{00AD}")
            for i in 0..<components.count {
                var component = components[i]
                let lineBreak = component.hasPrefix("\n")
                component = lineBreak ? component.substring(from: 1) : component
                
                let range3 = NSRange(location: loc, length: component.count)
                var rect = rectOfTextRange(range: range3)
                let rects = rectsOfTextRange(range: range3)
                if rects.count > 1 {
                    for i in 0..<rects.count {
                        if isRectValidate(line) {
                            results(line)
                        }
                        line = rects[i]
                    }
                    rect = rects.last!
                }
                
                if line.size.width == 0 {
                    line.origin = rect.origin
                    line.size.height = rect.size.height
                }
                if rect.origin.y == line.origin.y {
                    let max = rect.origin.x + rect.size.width
                    line.size.width = max - line.origin.x
                } else {
                    let isAutoLineBreak = !lineBreak && i != 0
                    if isAutoLineBreak {
                        line.size.width += _hyphenWidth ?? 0
                    }
                    if isRectValidate(line) {
                        results(line)
                    }
                    line = rect
                }
                
                loc += range3.length
                if !component.hasSuffix("-") {
                    loc += 1
                }
            }
        }
        if isRectValidate(line) {
            results(line)
        }
    }
    
}

// MARK: - Private

extension TextView {
    
    private func lineSize() -> CGSize {
        return size(forWidth: CGFloat(MAXFLOAT))
    }
    
    private func isRectValidate(_ rect: CGRect) -> Bool {
        let values = [rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]
        for value in values where value.isInfinite || value.isNaN {
            return false
        }
        return true
    }
    
    private func setupText(_ text: String?) {
        if let text = text {
            let aText = NSMutableAttributedString(string: text)
            let fullRange = NSRange(location: 0, length: text.count)
            aText.addAttributes(attributes(), range: fullRange)
            
            if let accent = accentText, let color = accentTextColor, let textRange = text.range(of: accent) {
                let range = NSRange(textRange, in: text)
                aText.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            }
            
            attributedText = aText
        } else {
            super.text = nil
        }
    }
    
    private func correct(range: NSRange, forText text: String?) -> NSRange {
        var range = range
        if range.location > (text?.count ?? 0) {
            return NSRange(location: 0, length: 0)
        }
        if range.location + range.length > (text?.count ?? 0) {
            range.length = (text?.count ?? 0) - range.location
        }
        return range
    }
    
    private func rectOfTextRange(range: NSRange) -> CGRect {
        let start = position(from: beginningOfDocument, offset: range.location)
        
        var end: UITextPosition? = nil
        if let start = start {
            end = position(from: start, offset: range.length)
        }
        var textRange2: UITextRange? = nil
        if let start = start, let end = end {
            textRange2 = textRange(from: start, to: end)
        }
        var rect: CGRect? = nil
        if let textRange = textRange2 {
            rect = firstRect(for: textRange)
        }
        return convert(rect ?? CGRect.zero, from: textInputView)
    }
    
    private func rectsOfTextRange(range: NSRange) -> [CGRect] {
        let start = position(from: beginningOfDocument, offset: range.location)
        
        var end: UITextPosition? = nil
        if let start = start {
            end = position(from: start, offset: range.length)
        }
        var textRange2: UITextRange? = nil
        if let start = start, let end = end {
            textRange2 = textRange(from: start, to: end)
        }
        var rects = [UITextSelectionRect]()
        if let textRange = textRange2 {
            rects = selectionRects(for: textRange)
        }
        return rects.filter { $0.rect.width != 0 }.map { convert($0.rect, from: textInputView) }
    }
    
}
