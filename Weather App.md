# What is the goal for the app
* Get the weather for any specific location.
* You imput a location it output the weather of that location as longer the location is valid.

# How to achieve the goal
## Solve a simpler problem first
### How to get weather info from your current location
1. Get the phone GPS coordinates
1. Send those coordinates to a weather website: To get the weather condition from those specific coordinates
1. Output the weather condition from the website to the screen.


# How to achive the the plan

## Setting up the locationManager
1. Import all the 
    `import CoreLocation`
    `import Alamofire`*
    `import SwiftyJSON`*
    * You can use cocopads to install them inyour project
1. inherite `CLLocationManagerDelegate`
1. `let locationManager = CLLocationManager()`
1. under the viewDidLoad() make your viewController the delegate. 
   `locationManager.delegate = self`
1. set the accuracy for the data 
    `locationManager.desiredAccuracy = kCLLoactionAcuracyHundredMeters`
1. Request for permission form the user to get their device location
    `locationManager.requestWhenInUseAuthorization()`

## Asking the user for Location Permission
* You won't be able to see the persion pop up come up. to fix that. 
1. go to the Supporting Filles > Info.plist
Add two key: Privacy - Location Usage De...
             Privacy - Location When In Use ...
1. Add appropriate values to each of those keys 
1. right click on the info.plist and open it as a source code.
1. copy paste the code in README.md under heading `Fix for App Transport Security Override`
1. Paste the code after the value of the last key you just created. 
1. run the app, the pop should appear and click allow. 
