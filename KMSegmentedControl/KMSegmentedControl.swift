//
//  KMSegmentedControl.swift
//  KMSegmentedControl
//
//  Created by Kamil Mazurek on 31/05/16.
//  Copyright © 2016 KamilMazurek. All rights reserved.
//

import UIKit

public protocol KMSegmentedControlDelegate {
  func KMSegmentedControl(selected item: UIButton)
}

@IBDesignable public class KMSegmentedControl: UIView {

  public enum UIElement {
    case HighlightedView
    case SelectorLine
  }

  var delegate: KMSegmentedControlDelegate?

  // MARK : Private Variables

  private var buttons = [UIButton]()

  private var selectedItem: UIButton?

  private var selectedTitleColor: UIColor?
  private var unSelectedTitleColor: UIColor?

  private var seperatorLines = [UIView]()

  private var highlightedView = UIView()
  private var selectorLine = UIView()

  private var showSeperatorLines: Bool = true
  private var showHighlightedView: Bool = true

  private var label = UILabel()

  // MARK : Customization Properties

  public var KMFontSize: CGFloat = 14 {
    didSet {
      setFont(KMFontSize)
    }
  }

  @IBInspectable public var KMSelectedItemColor: UIColor? {
    didSet {
      self.selectedItem?.backgroundColor = KMSelectedItemColor
    }
  }

  @IBInspectable public var KMBorderWidth: CGFloat = 0 {
    didSet {
      self.layer.borderWidth = KMBorderWidth
    }
  }

  @IBInspectable public var KMBorderColor: UIColor? {
    didSet {
      self.layer.borderColor = KMBorderColor?.CGColor
    }
  }

  @IBInspectable public var KMBackgroundColor: UIColor? {
    didSet {
      self.backgroundColor = KMBackgroundColor
    }
  }

  @IBInspectable public var KMCornerRadius: CGFloat = 0 {
    didSet {
      self.layer.cornerRadius = KMCornerRadius
      self.layer.masksToBounds = true
    }
  }

  @IBInspectable public var KMSelectedTitleColor: UIColor? {
    didSet {
      self.selectedTitleColor = KMSelectedTitleColor
    }
  }

  @IBInspectable public var KMUnSelectedTitleColor: UIColor? {
    didSet {
      self.unSelectedTitleColor = KMUnSelectedTitleColor
    }
  }

  @IBInspectable public var KMSelectorLineColor: UIColor? {
    didSet {
      selectorLine.backgroundColor = KMSelectorLineColor
    }
  }

  @IBInspectable public var KMHighlightedViewColor: UIColor? {
    didSet {
      highlightedView.backgroundColor = KMHighlightedViewColor
    }
  }

  public var items: [String] = ["Banana", "Apple"] {
    didSet {
      setupKMSegmentedControl()
    }
  }

	public var images: [String] = [] {
		didSet {
			setupKMSegmentedControl()
		}
	}

	public var placeImageAboveTitle: Bool = false {
		didSet {
			setupKMSegmentedControl()
		}
	}

  public var KMShowSeperatorLines: Bool? {
    didSet {
      showSeperatorLines = KMShowSeperatorLines!
      setupSeperatorLines()
    }
  }

  public var KMShowHighlightedView: Bool? {
    didSet {
      showHighlightedView = KMShowHighlightedView!
    }
  }

  public var UIElements: [UIElement] = [.HighlightedView, .SelectorLine] {
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

  override public func prepareForInterfaceBuilder() {
    items = ["First", "Second", "Third"]
    layoutIfNeeded()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    var selectFrame = selectedItem!.frame
    if UIElements.contains(.SelectorLine) {
      let newWidth = CGRectGetWidth(selectFrame) + 0.5
      selectFrame.size.width = newWidth
      selectFrame.size.height = 4.0
      selectFrame.origin.y = (selectedItem?.frame.height)! - 4
      selectorLine.frame = selectFrame
      selectorLine.backgroundColor = KMSelectorLineColor
      addSubview(selectorLine)
    }

    if UIElements.contains(.HighlightedView) {
      highlightedView.frame = CGRect(x: 0, y: 0, width: selectedItem!.frame.width - 4.0, height: selectedItem!.frame.height - 4.0)
      highlightedView.center = selectedItem!.center
      highlightedView.backgroundColor = KMHighlightedViewColor
      highlightedView.layer.cornerRadius = KMCornerRadius
      insertSubview(highlightedView, atIndex: 0)
    }

    if showSeperatorLines {
      setupSeperatorLines()
    }
  }

  private func setupSeperatorLines() {

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

  private func setupKMSegmentedControl() {

    for button in buttons {
      button.removeFromSuperview()
    }
    buttons.removeAll(keepCapacity: true)

    for i in 0...items.count - 1  {
      var button = UIButton()
      button.tag = i
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle(items[i], forState: .Normal)
      button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
      button.addTarget(self, action: #selector(didTapButton(_:)), forControlEvents: .TouchDown)
      button.setTitleColor(i == 0 ? KMSelectedTitleColor : KMUnSelectedTitleColor, forState: .Normal)
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
        constraints.append(button.widthAnchor.constraintEqualToAnchor(buttons[index + 1].widthAnchor))
      }
      constraints.append(button.topAnchor.constraintEqualToAnchor(self.topAnchor))
      constraints.append(button.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor))
      if index == 0 {
        constraints.append(button.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor))
      } else if index == buttons.count - 1 {
        constraints.append(button.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor))
      }
      if prevButton != nil {
        constraints.append(button.leadingAnchor.constraintEqualToAnchor(prevButton?.trailingAnchor))
      }
      NSLayoutConstraint.activateConstraints(constraints)
      prevButton = button
    }
  }

  // MARK : Action Handling

  func didTapButton(button: UIButton) {
    selectedItem?.backgroundColor = self.backgroundColor
    selectedItem?.enabled = true
    selectedItem?.setTitleColor(KMUnSelectedTitleColor, forState: .Normal)
    selectedItem = button

    if KMSelectedItemColor != nil {
      button.backgroundColor = KMSelectedItemColor
    } else {
      button.backgroundColor = self.backgroundColor?.darkerColor()
    }

    if UIElements.contains(.SelectorLine) {
      UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseOut], animations: {
        self.selectorLine.frame = CGRect(x: CGFloat(button.frame.width) * CGFloat(button.tag) , y: button.frame.height - 4.0, width: CGFloat(button.frame.width), height:4.0)
        }, completion: nil)
    }

    if UIElements.contains(.HighlightedView) {
      UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: . CurveEaseOut, animations: {
        self.highlightedView.frame = CGRect(x: 0, y: 0, width: button.frame.width - 4.0, height: button.frame.height - 4.0)
        self.highlightedView.center = button.center
        }, completion: nil)
    }

    button.enabled = false
    button.setTitleColor(KMSelectedTitleColor, forState: .Normal)
		if !images.isEmpty {
			selectedItem!.setImage(UIImage(named: images[button.tag]), forState: .Highlighted)
			selectedItem!.setImage(UIImage(named: images[button.tag]), forState: .Disabled)
		}
    delegate?.KMSegmentedControl(selected: button)
  }

  // MARK : Helper Methods

  func setFont(size: CGFloat) {
    for item in buttons {
      item.titleLabel?.font = UIFont.systemFontOfSize(size)
    }
  }

	private func setImage(named: String, inout button: UIButton) {
		let image = UIImage(named: named)
		image?.imageWithRenderingMode(.AlwaysOriginal)
		button.setImage(image, forState: .Normal)
	}

	private func setupButton(inout button: UIButton) {
		let spacing: CGFloat = 6.0
		let imageSize: CGSize = button.imageView!.image!.size
		button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
		let labelString = NSString(string: button.titleLabel!.text!)
		let titleSize = labelString.sizeWithAttributes([NSFontAttributeName: button.titleLabel!.font])
		button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
	}
}
