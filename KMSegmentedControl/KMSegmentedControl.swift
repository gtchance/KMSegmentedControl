//
//  KMSegmentedControl.swift
//  KMSegmentedControl
//
//  Created by Kamil Mazurek on 31/05/16.
//  Copyright © 2016 KamilMazurek. All rights reserved.
//

import UIKit

public protocol KMSegmentedControlDelegate: class {
    func KMSegmentedControlItemSelected(_ item: UIButton)
}

@IBDesignable open class KMSegmentedControl: UIView {

    public enum UIElement {
        case highlightedView
        case selectorLine
    }

    open weak var delegate: KMSegmentedControlDelegate?

    // MARK : Private Variables

    fileprivate var buttons = [UIButton]()

    fileprivate(set) var selectedItem: UIButton?

    fileprivate var selectedTitleColor: UIColor?
    fileprivate var unSelectedTitleColor: UIColor?

    fileprivate var seperatorLines = [UIView]()

    fileprivate var highlightedView = UIView()
    fileprivate var selectorLine = UIView()

    fileprivate var showSeperatorLines: Bool = true
    fileprivate var showHighlightedView: Bool = true

    fileprivate var label = UILabel()

    // MARK : Customization Properties

    open var KMFontSize: CGFloat = 14 {
        didSet {
            setFont(KMFontSize)
        }
    }

    @IBInspectable open var KMSelectedItemColor: UIColor? {
        didSet {
            self.selectedItem?.backgroundColor = KMSelectedItemColor
        }
    }

    @IBInspectable open var KMBorderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = KMBorderWidth
        }
    }

    @IBInspectable open var KMBorderColor: UIColor? {
        didSet {
            self.layer.borderColor = KMBorderColor?.cgColor
        }
    }

    @IBInspectable open var KMBackgroundColor: UIColor? {
        didSet {
            self.backgroundColor = KMBackgroundColor
        }
    }

    @IBInspectable open var KMCornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = KMCornerRadius
            self.layer.masksToBounds = true
        }
    }

    @IBInspectable open var KMSelectedTitleColor: UIColor? {
        didSet {
            self.selectedTitleColor = KMSelectedTitleColor
        }
    }

    @IBInspectable open var KMUnSelectedTitleColor: UIColor? {
        didSet {
            self.unSelectedTitleColor = KMUnSelectedTitleColor
        }
    }

    @IBInspectable open var KMSelectorLineColor: UIColor? {
        didSet {
            selectorLine.backgroundColor = KMSelectorLineColor
        }
    }

    @IBInspectable open var KMHighlightedViewColor: UIColor? {
        didSet {
            highlightedView.backgroundColor = KMHighlightedViewColor
        }
    }

    open var items: [String] = ["Banana", "Apple"] {
        didSet {
            setupKMSegmentedControl()
        }
    }

    open var selectedIndex: Int? {
        guard let selectedItemTitle = selectedItem?.title(for: UIControlState()) else { return nil }
        return items.index(of: selectedItemTitle)
    }

    open var images: [String] = [] {
        didSet {
            setupKMSegmentedControl()
        }
    }

    open var placeImageAboveTitle: Bool = false {
        didSet {
            setupKMSegmentedControl()
        }
    }

    open var KMShowSeperatorLines: Bool? {
        didSet {
            showSeperatorLines = KMShowSeperatorLines!
            setupSeperatorLines()
        }
    }

    open var KMShowHighlightedView: Bool? {
        didSet {
            showHighlightedView = KMShowHighlightedView!
        }
    }

    open var UIElements: [UIElement] = [.highlightedView, .selectorLine] {
        didSet {
            setupKMSegmentedControl()
        }
    }

    // MARK : Initialitation

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupKMSegmentedControl()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupKMSegmentedControl()
    }

    // MARK : Setup

    override open func prepareForInterfaceBuilder() {
        items = ["First", "Second", "Third"]
        layoutIfNeeded()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        var selectFrame = selectedItem!.frame
        if UIElements.contains(.selectorLine) {
            let newWidth = selectFrame.width + 0.5
            selectFrame.size.width = newWidth
            selectFrame.size.height = 4.0
            selectFrame.origin.y = (selectedItem?.frame.height)! - 4
            selectorLine.frame = selectFrame
            selectorLine.backgroundColor = KMSelectorLineColor
            addSubview(selectorLine)
        }

        if UIElements.contains(.highlightedView) {
            highlightedView.frame = CGRect(x: 0, y: 0, width: selectedItem!.frame.width - 4.0, height: selectedItem!.frame.height - 4.0)
            highlightedView.center = selectedItem!.center
            highlightedView.backgroundColor = KMHighlightedViewColor
            highlightedView.layer.cornerRadius = KMCornerRadius
            insertSubview(highlightedView, at: 0)
        }

        if showSeperatorLines {
            setupSeperatorLines()
        }
    }

    fileprivate func setupSeperatorLines() {

        if !showSeperatorLines {
            return
        } else {
            for line in seperatorLines {
                line.removeFromSuperview()
            }
            seperatorLines.removeAll()
            for index in 0..<buttons.count {
                let xPos: CGFloat = buttons[index].frame.width * CGFloat(index)
                let line = UIView(frame: CGRect(x: (buttons[index].frame.width) * CGFloat(index), y: 0, width: KMBorderWidth, height: self.frame.height))
                line.center.x = xPos
                line.backgroundColor = KMBorderColor
                seperatorLines.append(line)
                addSubview(line)
            }
        }
        print(seperatorLines.count)
    }

    fileprivate func setupKMSegmentedControl() {

        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll(keepingCapacity: true)

        for i in 0...items.count - 1  {
            var button = UIButton()
            button.tag = i
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(items[i], for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchDown)
            button.setTitleColor(i == 0 ? KMSelectedTitleColor : KMUnSelectedTitleColor, for: UIControlState())
            if !images.isEmpty {
                setImage(images[i], button: &button)
                if placeImageAboveTitle {
                    setupButton(&button)
                }
            }
            buttons.append(button)
            addSubview(button)
        }

        if KMSelectedItemColor != nil {
            buttons[0].backgroundColor = KMSelectedItemColor
        } else {
            buttons[0].backgroundColor = self.backgroundColor?.darkerColor()
        }
        selectedItem = buttons[0]

        var prevButton: UIButton? = nil
        for index in 0..<buttons.count {
            var constraints: [NSLayoutConstraint] = []
            let button = buttons[index]
            if index < buttons.count - 1 {
                constraints.append(button.widthAnchor.constraint(equalTo: buttons[index + 1].widthAnchor))
            }
            constraints.append(button.topAnchor.constraint(equalTo: self.topAnchor))
            constraints.append(button.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            if index == 0 {
                constraints.append(button.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            } else if index == buttons.count - 1 {
                constraints.append(button.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            }
            if let prevButtonTrailing = prevButton?.trailingAnchor {
                constraints.append(button.leadingAnchor.constraint(equalTo: prevButtonTrailing))
            }
            NSLayoutConstraint.activate(constraints)
            prevButton = button
        }
    }
    open func selectItemAtIndex(_ index: Int) {
        selectItem(buttons[index])
    }

    fileprivate func selectItem(_ item: UIButton) {
        selectedItem?.backgroundColor = self.backgroundColor
        selectedItem?.isEnabled = true
        selectedItem?.setTitleColor(KMUnSelectedTitleColor, for: UIControlState())
        selectedItem = item

        if KMSelectedItemColor != nil {
            item.backgroundColor = KMSelectedItemColor
        } else {
            item.backgroundColor = self.backgroundColor?.darkerColor()
        }

        if UIElements.contains(.selectorLine) {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.selectorLine.frame = CGRect(x: CGFloat(item.frame.width) * CGFloat(item.tag) , y: item.frame.height - 4.0, width: CGFloat(item.frame.width), height:4.0)
            }, completion: nil)
        }

        if UIElements.contains(.highlightedView) {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: . curveEaseOut, animations: {
                self.highlightedView.frame = CGRect(x: 0, y: 0, width: item.frame.width - 4.0, height: item.frame.height - 4.0)
                self.highlightedView.center = item.center
            }, completion: nil)
        }

        item.isEnabled = false
        item.setTitleColor(KMSelectedTitleColor, for: UIControlState())
        if !images.isEmpty {
            selectedItem!.setImage(UIImage(named: images[item.tag]), for: .highlighted)
            selectedItem!.setImage(UIImage(named: images[item.tag]), for: .disabled)
        }
        delegate?.KMSegmentedControlItemSelected(item)
        selectedItem?.backgroundColor = self.backgroundColor
        selectedItem?.isEnabled = true
        selectedItem?.setTitleColor(KMUnSelectedTitleColor, for: UIControlState())
        selectedItem = item

        if KMSelectedItemColor != nil {
            item.backgroundColor = KMSelectedItemColor
        } else {
            item.backgroundColor = self.backgroundColor?.darkerColor()
        }

        if UIElements.contains(.selectorLine) {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.selectorLine.frame = CGRect(x: CGFloat(item.frame.width) * CGFloat(item.tag) , y: item.frame.height - 4.0, width: CGFloat(item.frame.width), height:4.0)
            }, completion: nil)
        }

        if UIElements.contains(.highlightedView) {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: . curveEaseOut, animations: {
                self.highlightedView.frame = CGRect(x: 0, y: 0, width: item.frame.width - 4.0, height: item.frame.height - 4.0)
                self.highlightedView.center = item.center
            }, completion: nil)
        }

        item.isEnabled = false
        item.setTitleColor(KMSelectedTitleColor, for: UIControlState())
        if !images.isEmpty {
            selectedItem!.setImage(UIImage(named: images[item.tag]), for: .highlighted)
            selectedItem!.setImage(UIImage(named: images[item.tag]), for: .disabled)
        }
        delegate?.KMSegmentedControlItemSelected(item)
    }

    // MARK : Action Handling

    func didTapButton(_ button: UIButton) {
        selectItem(button)
    }

    // MARK : Helper Methods

    func setFont(_ size: CGFloat) {
        for item in buttons {
            item.titleLabel?.font = UIFont.systemFont(ofSize: size)
        }
    }

    fileprivate func setImage(_ named: String, button: inout UIButton) {
        let image = UIImage(named: named)
        image?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: UIControlState())
    }

    fileprivate func setupButton( _ button: inout UIButton) {
        let spacing: CGFloat = 6.0
        let imageSize: CGSize = button.imageView!.image!.size
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        let labelString = NSString(string: button.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
    }
}
