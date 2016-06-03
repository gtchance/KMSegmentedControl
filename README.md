# KMSegmentedControl



## This library is still under development

Note: This library might contain some small bugs but it will be fixed as soon as possible. However, it won't affect any of its funtionalities. It's planned
to develop further functions that will make it more dynamic and cleaner.

### Screenshot

upcoming...

### Setup with CocoaPods

- Add ```pod 'KMSegmentedControl' ``` to your Podfile
- Run ```pod install``` in your Terminal
- Run Project ```pod 'YourApp'.xcworkspace```

## Usage

### Swift

**Import library**

```swift 
import KMSegmentedControl
```

**Create KMSegmentedControl programmatically:**

```swift
var segmentedControl = KMSegmentedControl(frame: CGRect(x: 0,y: 0, width: 200, height: 50))
segmentedControl.delegate = self
// further customizable properties are listed below
```

**Create KMSegmentedControl with storyboard:**

- Create a new UIView inheriting from KMSegmentedControl
- Design it according to your own preferences.

**Delegate Methods**

```swift
// called if an action happens. Control different behaviours by checking item.tag.
func KMSegmentedControl(selected item: UIButton) 
```

**Properties**

Properties with @IBInspectable are customizable with storyboard but also in code.

```swift
public var KMFontSize: CGFloat = 14 // font size of each item
@IBInspectable public var KMSelectedItemColor: UIColor?  // background of selected item
@IBInspectable public var KMBorderWidth: CGFloat = 0  // border width of the segmented control
@IBInspectable public var KMBorderColor: UIColor? // color of the border
@IBInspectable public var KMBackgroundColor: UIColor? // background color of segmented control 
@IBInspectable public var KMCornerRadius: CGFloat = 0 // corner radius of segmented control
@IBInspectable public var KMSelectedTitleColor: UIColor? // color of the selected item
@IBInspectable public var KMUnSelectedTitleColor: UIColor?  // default title color
@IBInspectable public var KMSelectorLineColor: UIColor? // color of the animated bottom line
public var items: [String] = ["First", "Second"] // defines what items will be displayed
public var KMShowSeperatorLines: Bool? // display seperator lines between each item
```
## License

KMSegmentedControl is available under the MIT license. See the <a href="https://github.com/YounZ/KMSegmentedControl/blob/master/LICENSE">LICENSE</a> file for more info.


