//
//  WeatherViewController.swift
//  Climate App
//
//  Created by Mohamed on 1/17/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    //Constant
   // let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Latitude)&lon=\(Longitude)"
    let APP_ID = "25e7d4abbaecb0169ca7fbac3f8bd0c0"
   
    
    
    //Declare Variables
    let locationManager = CLLocationManager() // create object to access his properties
    let weather_Data = weatherDataModel()
    
    
    
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var CityLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setup location manager here
        locationManager.delegate = self  // to get GPS Coordinates
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //the more accuracy the more we consume battery so we have what type of our app
        locationManager.requestWhenInUseAuthorization() // to make permission from user
        // go to info.plist to use the two properties we add
        locationManager.startUpdatingLocation() // asynchronous method works in the background
        
        

    }
    
    //MARK: - Networking
    /*******************************************************/
    
    // Write the getWeatherData method here:
    
    func getWeatherData(url: String, parameters: [String:String])
    {
        // alamofire to make http request
        // in order to do networking we have to provide a URL
        // asynchronous method happens in the background
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            
            if response.result.isSuccess{
                
                print("Success! we have got the Data!!")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            }else{
             print("Error is \(response.result.error)")
                self.CityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /*******************************************************/
    
    // updateWeatherData Method :
    func updateWeatherData(json: JSON){
        
        if let tempResults = json["main"]["temp"].double {
        weather_Data.temperature = Int(tempResults - 273.15)
        
        weather_Data.city = json["name"].stringValue
        
        weather_Data.condition = json["weather"][0]["id"].intValue
        
        weather_Data.weatherIconName = weather_Data.updateWeatherIcon(condition: weather_Data.condition)
            
            updateUIWithWeatherData()
        
        }else
        {
            CityLabel.text = "Weather unavailable"
        }
    }
    
   
    
    
    //MARK: - JSON Parsing
    /*******************************************************/
    
    // updateUIWithWeatherData Method:
    func updateUIWithWeatherData(){
       
        CityLabel.text = weather_Data.city
        TemperatureLabel.text = String(weather_Data.temperature)
        weatherIcon.image = UIImage(named: weather_Data.weatherIconName)
        
    }

    
    
    //MARK: - Location Manager Delegate Methods
    /*******************************************************/
    
    // Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    let location = locations[locations.count - 1]
        // to ensure that the location is a vaild one
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation() // to save battery
            locationManager.delegate = nil
            
            print("Longitude = \(location.coordinate.longitude) and Latitude = \(location.coordinate.latitude)")
            
            
            let Latitude = "\(location.coordinate.latitude)"
            let Longitude = "\(location.coordinate.longitude)"
            
            
            let parms: [String : String] = ["Lat": Latitude, "Long": Longitude, "appid": APP_ID]
            
            getWeatherData(url: "http://api.openweathermap.org/data/2.5/weather?lat=\(Latitude)&lon=\(Longitude)", parameters: parms)
        }
        
        
    }
    
    // write the didFailWirhError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
        CityLabel.text = "Location Unavailable"
    }
    
    
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ChangeCityName", sender: self)
    }
    
    //MARK: - Change City Delegate Methods
    /*******************************************************/
    
    // UserEnteredAnewCityName Delegate Method
    func userEnterAnewCityName(city: String) {
        let params: [String:String] = ["q": city , "appid": APP_ID]
        getWeatherData(url: "http://api.openweathermap.org/data/2.5/weather?q=\(city)", parameters: params)
    }
    
    // prepareforsegue method:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeCityName"
        {
            let destinationVC = segue.destination as! changeCityViewController
            destinationVC.deledate = self
        }
    }
}
