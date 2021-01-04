//
//  ColorBackgroundTextView.swift
//
//  Created by Nick Ignatenko on 2021-01-04.
//

import UIKit

class ColorBackgroundTextView: UIView {
    
    enum ColorBackgroundStyle {
        case title
        case text
    }
    var style: ColorBackgroundStyle = .title
    
    var isShowColorBackground = true {
        didSet {
            for view in backgroundViews {
                view.isHidden = !isShowColorBackground
            }
        }
    }
    
    var numberOfLines = 0
    
    var color: UIColor? {
        didSet {
            createViews()
        }
    }
    
    var font: UIFont? {
        didSet {
            textView.font = font
        }
    }
    
    var lineHeight: CGFloat? {
        didSet {
            if let height = lineHeight {
                textView.lineHeight = height
            }
        }
    }
    
    var characterSpacing: CGFloat? {
        didSet {
            textView.characterSpacing = characterSpacing
        }
    }
    
    var textColor: UIColor? {
        didSet {
            textView.textColor = textColor
        }
    }
    
    var textAlignment: NSTextAlignment? {
        didSet {
            if let textAlignment = textAlignment {
                textView.textAlignment = textAlignment
            }
        }
    }
    
    var extraInsets: UIEdgeInsets?
    
    var text: String? {
        didSet {
            textView.text = text
            setNeedsLayout()
        }
    }
    
    private lazy var textView = makeTextView()
    private var backgroundViews: [UIView] = []
    private var linesCount = 0
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = bounds
        if numberOfLines <= 0 {
            rect.height = textView.height()
        } else {
            rect.height = textView.lineHeight * CGFloat(numberOfLines)
        }
        textView.frame = rect
        createViews()
        
        heightConstraint?.constant = rect.height
        layoutIfNeeded()
    }
    
    // MARK: - Make constraints
    
    private func makeConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        heightConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        heightConstraint?.isActive = true
    }
    
    // MARK: - Lazy initialization
    
    private func makeTextView() -> TextView {
        let textView = TextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        addSubview(textView)
        return textView
    }
    
}

// MARK: - Private

extension ColorBackgroundTextView {
    
    private func deleteViews() {
        for view in backgroundViews {
            view.removeFromSuperview()
        }
        backgroundViews.removeAll()
    }
    
    private func createViews() {
        deleteViews()
        
        guard let color = color, frame != .zero, let lines = allLines() else { return }
        let fontHeight = font?.pointSize ?? 0
        let linesHeight = lineHeight ?? fontHeight
        let inset: CGFloat = 8.0
        let extraInsets = self.extraInsets ?? .zero
        
        for line in lines  {
            let view = UIView()
            view.backgroundColor = color
            
            var rect = line
            if style == .title  {
                rect.origin.x -= inset + extraInsets.left
                rect.origin.y -= inset / 2 + (linesHeight / 12 + (fontHeight - linesHeight) / 2) + extraInsets.top
                rect.size.width += inset * 2 + extraInsets.left + extraInsets.right
                rect.size.height += inset + extraInsets.top + extraInsets.bottom

                view.layer.cornerRadius = inset / 2
                
            } else if style == .text {
                let height = textView.lineHeight / 2
                rect.origin.x -= 1 + extraInsets.left
                rect.origin.y = rect.maxY - height - 1 - extraInsets.top
                rect.size.width += 2 + extraInsets.left + extraInsets.right
                rect.size.height = height + extraInsets.top + extraInsets.bottom
            }
                
            view.frame = rect
            view.isHidden = !isShowColorBackground
            addSubview(view)
            sendSubviewToBack(view)
            backgroundViews.append(view)
        }
    }
    
    private func allLines() -> [CGRect]? {
        guard let text = text else { return nil }
        
        var rects = [CGRect]()
        textView.calculateLines(forText: text, range: text.fullRange()) { rect in
            rects.append(rect)
        }
        linesCount = rects.count
        return rects
    }
    
}
