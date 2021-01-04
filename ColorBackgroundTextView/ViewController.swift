import UIKit

class ViewController: UIViewController {
    
    private var textView1: ColorBackgroundTextView!
    private var textView2: ColorBackgroundTextView!
    private var textView3: ColorBackgroundTextView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTestColorBackgroundTextView1()
        setupTestColorBackgroundTextView2()
        setupTestColorBackgroundTextView3()
    }
    
    // MARK: - Several examples
    
    private func setupTestColorBackgroundTextView1() {
        // View
        let textView = ColorBackgroundTextView()
        textView.font = UIFont(name: "ObjectSans-Heavy", size: 21)
        textView.lineHeight = 23
        textView.characterSpacing = -0.42
        textView.numberOfLines = 0
        textView.textAlignment = .center
        textView.textColor = .white
        textView.color = UIColor(red: 0.349, green: 0.498, blue: 0.878, alpha: 1)
        textView.text = "Color background\ntext view"
        view.addSubview(textView)
        textView1 = textView
        
        // Constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -200).isActive = true
    }
    
    private func setupTestColorBackgroundTextView2() {
        // View
        let textView = ColorBackgroundTextView()
        textView.font = UIFont(name: "ObjectSans-Heavy", size: 32)
        textView.lineHeight = 36
        textView.characterSpacing = 0
        textView.numberOfLines = 0
        textView.textAlignment = .left
        textView.textColor = .green
        textView.color = .blue
        textView.text = "Left alignment\ntext view with\nmultiple lines\n...\nmaybe too many"
        view.addSubview(textView)
        textView2 = textView
        
        // Constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: textView1, attribute: .bottom, multiplier: 1, constant: 100).isActive = true
    }
    
    private func setupTestColorBackgroundTextView3() {
        // View
        let textView = ColorBackgroundTextView()
        textView.font = UIFont(name: "ObjectSans-BoldSlanted", size: 13)
        textView.lineHeight = 13
        textView.characterSpacing = 2.0
        textView.numberOfLines = 0
        textView.textAlignment = .right
        textView.textColor = .black
        textView.color = .gray
        textView.extraInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        textView.text = "Right alignment\ntext view\nwith some extra text"
        view.addSubview(textView)
        textView3 = textView
        
        // Constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: -24).isActive = true
        NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: -100).isActive = true
    }
    
}
