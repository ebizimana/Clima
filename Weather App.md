# What is the goal for the app
* Get the weather for any specific location.
* You imput a location it output the weather of that location as longer the location is valid.

# How to achieve the goal
## Solve a simpler problem first
### How to get weather info from your current location
1. Get the phone GPS coordinates
1. Send those coordinates to a weather website: To get the weather condition from those specific coordinates
1. Output the weather condition from the website to the screen.

## The more complex challenge
### How to get weather condition from the imput location
* I have to validate if the place you inputted is valid place, must be in the database
  * if it's not a valid place I output a message saying to please input a valid place
  * if it's valid place I get the coordinates for that place from a database I built
  * The database should look like this:
      |Location Name  | Coordinates       |API_ID|
      |---------------|-------------------|-----|
      |Rio            |lat:1901 lon:1232  |12433|
      |NewYork        |lat:1243 lon:14334 |12433|
  * send the coordinates to the weather website
  * display the weather condition on the screen

# More Detailed Plan
* WeatherViewControl: The home screen
  * On launch
    * Get the current location weather condition and display them
  * when `Get weather` is pressed
    * Get the location inputted and display the weather condition of that specific location
* SeachLocationViewController: The second screen
  * A label: for inputing a Location
  * A button `Get Weather` to swicth to the home screen and carry data

# How to achive the the plan
* WeatherViewControl:
  * import `CoreLocation`: A library developed by apple to get the GPS coordinates from the device and give it to the [delegate](https://www.andrewcbancroft.com/2015/04/08/how-delegation-works-a-swift-developer-guide/ "A class to receive the GPS data once CoreLocation has finished finding them").
  * Declare the WeatherViewControl as the delegate: to deal with the data from the `CoreLocation`
  * Ask for permission from the user to get the GPS coordinates from their device
  * Start fetching for the coordinates

  * You need an API_ID from the weather website to use their data
  * make a function to actually get the data from the `CoreLocation` and throw them in a variable
  * send the lattitude and longitude and API_ID to the weather website: make sure you follow the API documatation
  * weather website gives you JSON data: so you need to parse JSON and only display the info you want.
  * Don't forget to stop fetching the coordinates once you got the valid coordinates. Not drain the user battery
