# FJCalendarView
Calendar component made in Objective-C

![alt text](https://raw.githubusercontent.com/fedejordan/FJCalendarView/master/demo.gif)

> This project has started as a component in a freelance job and I want to open the code in case anyone need the same functionality.

### Main features
+ Select and deselect a day, and inform the date with the delegate.
+ Set days as unavailable and available again.
+ Get selected date string

### Installation
Clone the repository and copy the folder `FJCalendar` to your project. Add `#import "FJCalendarView.h"` to your view controller or class that needs to use it.
> If you need Swift support, [here](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html) is some info about how to support Objective-C files in Swift projects

### Usage
Add a `UIView` component to your view controller xib or storyboard and change the class name (in the second tab of Utilites panel) to `FJCalendarView`. 

You may want to implement `FJCalendarViewDelegate` (in the calendar `delegate` property) to know when the user:
+ Change the month (and maybe the year) with the calendar arrows
+ Select a certain day, with also knowing the month and year

Feel free to report any issue or submit any pull request.
Thank you very much!


Federico Jordan

fedejordan99@gmail.com

[@FedeJordan90](https://www.twitter.com/FedeJordan90)
