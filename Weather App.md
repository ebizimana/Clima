# What is the goal for the app
* Get the weather for any specific location.
* You imput a location it output the weather of that location as longer the location is valid.

# How to achive the the plan

## Setting up the locationManager
1. Import all the 
    `import CoreLocation`
    `import Alamofire`*
    `import SwiftyJSON`*
    * \* You can use cocopads to install them in your project
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
    * Add two key: 
        * Privacy - Location Usage De...
        * Privacy - Location When In Use ...
1. Add appropriate values to each of those keys 
1. right click on the info.plist and open it as a source code.
1. copy paste the code in README.md under heading `Fix for App Transport Security Override`
1. Paste the code after the value of the last key you just created. 
1. run the app, the pop should appear and click allow. 

## Tapping into the GPS
1. Let's start getting the GPS coordinates of the device. Under viewDidLoad() add this line.
    `locationManager.startUpdatingLocation()`
    * This is an Asynchronous Method: It works in the background so it doesn't freez the app.
    * After `.startUpdatingLocation` finishes. we need to get the result from a method called `didUpdateLocations`
1. Under the `MARK: - Location Manager Delegate Methods`
1. write two delegate method 
    * ` func didUpdateLocation` the full function name will pop up and tap enter
        * it tells the delegate the new location data is available 
    * ` func didFailWithError` the full function name will pop up and tap enter
        * Tells the delegate that the location manager was unable to retrieve a location value
    * **NOTE**: Remember the `weatherViewController.swift` is the delegate because of this line. `locationManager.delegate = self`
1. Couple things to do in ` func didFailWithError`
    1. print the error. `print(error)`
    1. Tell the user that they have been a problem getting their location. 
    `cityLabel.text = "Location Unavailable"`
1. Couple things to do in ` func didUpdateLocation`
    * **NOTE:** diUpdateLocation gets the locations and stores them in `CLLocation` arrary.         it take couple tries to get the most accuracy data. In the `CLLocation` has a lot          of data that are not neccessary or accurate. 
    1. create a varaible to store the the last data in the array (the most accurate one). 
     `let location = locations[locations.count - 1]`
    1. We have to check the validatity of the data we got back. 
        ```Swift
        // to check if the value we got is not invalid
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params: [String : String] = ["lat" : latitude, "lon": longitude, "appid" : APP_ID ]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
        ```
        1. `horizontalAccuracy > 0` if any value that comes back is less than 0 then it's              invalid value
        1. You have to `stopUpdatingLocation()` as soon as you get a valid data. because 
            the method drains the battery so you want to stop it as soon as you can.
        1. The params `key` naming is according to the openweathermap API documatation
        1. `getWeatherData` is method that is Declared and explained in the Network with               Alamofire section 

## Networking with Alamofire
Under pragma mark called **Networking** we are going to do couple things 
1. We are going to write the getWeatherData function. This function will help us send           the data to the [open weather map](https://openweathermap.org/) and get the                weather condition to the coordinates we sent it (in the params) 
    ```Swift
        func getWeatherData(url: String, parameters: [String: String]) {
        // To retrieve data from the url 
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in 
                if response.result.isSuccess {
                    print("Success! Got the weather data")
                } else {
                    print("Error \(response.result.error)")
                    self.cityLabel.text = "Connection Issue"
                }
            }
        }
    ```
    1. Once the Alamofire gets the data from the website it stores them in a variable             called response. Now we want to check if that response was successful or faiure.
    1. The Alamofire.request method is an Asynchrous method. 
    1. To fully understand the Alamofire.request method read their                        [documatation](https://cocoapods.org/pods/Alamofire)

## JSON Parsing 
**Note:** All JSON is, is a format to pass a lot peirce of data on the internet. because we are going to get a tone of data from the open weather map, the data comes in the JSON format. we have to store it, and parse it. 
1. Add a variable to store the JSON data that comes back from the website
    ```Swift
        func getWeatherData(url: String, parameters: [String: String]) {
        // To retrieve data from the url 
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in 
                if response.result.isSuccess {
                    print("Success! Got the weather data")
                    // create a JSON variable to store the data
                    let weatherJSON: JSON = JSON(response.result.value!)
                } else {
                    print("Error \(response.result.error)")
                    self.cityLabel.text = "Connection Issue"
                }
            }
        }
    ```
    1. The data that comes back comes, come back as an optional, so we have to force              unwrape it.
        * it's ok to force unwrape this value, because we checked to see if the `response`           was successful (`response.result.isSuccess`) so we are certain `response`                 doesn't contain `nil`  
    1. The value has a data type of `Any` and we are trying to assisgn it to a data type          of `JSON` so we have to enclose it in JSON brackets 
        * This functionality is from the `SwiftyJSON`
1. It takes a couple minutes to stopUpdatingLocation(), so it will print a couple times.     To fix that. you just have to set the delegate to nil. Which remove our current class     from receving any communacation from the location Manager

     ```Swift
        // to check if the value we got is not invalid
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil             // The new line
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params: [String : String] = ["lat" : latitude, "lon": longitude, "appid" : APP_ID ]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
      ```
1. To better visualize the data you got, you can print it and copy paste it to [JSON Editor Online](https://jsoneditoronline.org/) 
1.     ```Swift
        func getWeatherData(url: String, parameters: [String: String]) {
        // To retrieve data from the url 
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in 
                if response.result.isSuccess {
                    print("Success! Got the weather data")
                    // The new lines
                    let weatherJSON: JSON = JSON(response.result.value!)
                    self.updateWeatherData(json: weatherJSON)
                    // The end of the new lines
                } else {
                    print("Error \(response.result.error)")
                    self.cityLabel.text = "Connection Issue"
                }
            }
        }
        ```
    1. Because you are in a Closure (a function inside another function) you have to              include `self` key word to call another function or variable. the `self` key word         tells the compiler to search the function/variable inside your file  `weatherViewControoler.swift`
1. Under pragma mark called **JSON Parsin** write the function to grab the data that you want only from the data you got from the website
    ```Swift
        func updateWeatherData(json: JSON) {
            let tempResult = json["main"]["temp"]
        }
    ```
    1. The whole `json` has 12 objects and they all nested in a specific order to navigate         to a            specific value you need, you use the method shown above. 
        1. This functionality is possible by `SwiftyJSON`

## Create a Weather Data Model 
** Note:** The big reson to do this, is to divide our app in the MVC (Model, View, Controller) format. We want to separate the weather data from the weather controll so incase the controll fail the data is still functioning. 
1. Switch to the `weatherDataModel.swift` file
1. Create four variables to store the weather data that we want to use in our app
    ```Swift
        var temperature = 0    // To store the temprature
        var condition = 0      // The id to use to get the weather icon
        var city = ""         // to store the name of the city
        var weatherIconName = ""   // to store the icon name to display on the screeen
    ```
1. switch back to `weatherViewController.swift`
1. create an object of the `weatherDataModel` class
    `let weatherDataModel = weatherDataModel()`
1. let's update the `weatherDataModel` in the `updateWeatherData` function
    ```Swift
        func updateWeatherData(json: JSON) {
           if  let tempResult = json["main"]["temp"].double {
                weatherDataModel.temperature = Int(tempResult - 273.15.)
                weatherDataModel.city = json["name"].stringValue
                weatherDataModel.condition = json["weather"][0]["id"].intValue
            }
        }
    ```
    ### Data Type Conversion
    1. `if let` is to make sure if the json is not valid our app doesn't crash.
        * the json value can be invalid if the any of the params value (lat, long, appid) are invalid. 
    1. `.double` converts the `tempResult` from a `JSON` data type to a `Double?` data type
        * `if let` is an **Optional Binding** which make sure that the `tempResult` is nver `nil` so we                don't have to force unwrap it. 
    1. We have to convert the `tempResult` from Kelvin to Celcius. hence `tempResult - 273.15`
    1. `temperature` is of `Int` data type so we have to `Int(...)` to convert it to `Int` from `Double`
    1. `.stringValue` converts `JSON` to `String`
    1. `.intValue` converts `JSON` to `Int`
    1. the `id` is a code that says what weather condition is (either: mist, sunny, snow...)
1. Switch to the `weatherViewController.swift` and uncomment the `updateWatherIcon` **full** function. the     `updateWatherIcon` is a function that takes the weather `id` aka `condition` and look for an               appropriate weather image to assign to that `condition`
1. Let's call the method to update the `weatherIconName`
    ```Swift
        func updateWeatherData(json: JSON) {
           if  let tempResult = json["main"]["temp"].double {
                weatherDataModel.temperature = Int(tempResult - 273.15.)
                weatherDataModel.city = json["name"].stringValue
                weatherDataModel.condition = json["weather"][0]["id"].intValue
                weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            } else {
                cityLabel.text = "Weather Unavaible"
            }
        }
    ```
    1. In case of invalid `params` beacuse of reason provided  above, we want to inform the user that the            weather condition was unavailable.

## Update the User Interface
* **Note:** under the pragama mark called **UI Update**  write a function `updateUIWithWeatherData`. This               function is to Update the User interface geting the data from the `weatherDataModel`
    ```Swift
        func updateUIWithWeatherData() {
            cityLabel.text = weatherDataWeather.city
            temperatureLabel.text = Sting(weatherDataModel.temperature)
            weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        }
    ```
    1. Our app only shows three things: City Name, Temperature of that City and the Weather Icon that goes        with that temperature
    1. with `Label` they always expeting `String` so you have to convert the `weatherDataModel.temperature`         to a `String`
    1. in the `image` folder there is a lot images and they are specificly named. `weatherIcon:UIImage`            just became a place they are placed amd the `weatherDataModel.weatherIconName` choose which one to         be displayed
1. lets call the function after Updating the Weateher Data:
    ```Swift
        func updateWeatherData(json: JSON) {
           if  let tempResult = json["main"]["temp"].double {
                weatherDataModel.temperature = Int(tempResult - 273.15.)
                weatherDataModel.city = json["name"].stringValue
                weatherDataModel.condition = json["weather"][0]["id"].intValue
                weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
                
                updateUIWithWeatherData()  // The New Line
            } else {
                cityLabel.text = "Weather Unavaible"
            }
        }
    ```
1. Run the App. Congraturation the First Part is Done. 

## Using Delegates and Protocols 
* Switch in `ChangeCityViewController.swift` file
* before the class declaration 
* We have to create a Protocol
    ```Swift
        protocol ChangeCityDelegate{
            func userEnteredANewCityName (city: String)
        }
        class ChangeCityViewController: UIViewController {
            var delegate: ChangeCityDelegate?
        }
    ```
* Switch back to the `WeatehrViewController.swift` inside we are going to do a couple things:
    * Inheret the `ChangeCityDelegate`
    * declare the function in the delegate
    ```Swift
        func userEnteredNewCityName(city: String) {
            
        }
    ```
