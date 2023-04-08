//
//  Location ViewController.swift
//  Project2_Krishna
//
//  Created by Krishna Priya on 2023-04-07.
//

import UIKit
import CoreLocation

class Location_ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tempLabel: UITextField!
    
    @IBOutlet weak var changetemp: UISwitch!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherconditionLabel: UILabel!
    
    
    var weatherResponse: WeatherResponse?
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    

    @IBAction func changeTemp(_ sender: UISwitch) {
        loadweather(search: locationLabel.text)
    }
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        print(textField.text ?? "")
        loadweather(search: searchTextField.text) // to return value when search key pressed in software keyboard
        return true
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
       {
           if let location = locations.last
           {
               let geocoder = CLGeocoder()
               geocoder.reverseGeocodeLocation(location)
               {
                   (placemarks, error) in
                  
                   if let error = error
                   {
                  
                   print("Error for place: \(error.localizedDescription)")
                   }
                  else if let placemark = placemarks?.first
                   {
                   if let place = placemark.locality
                      {
      
                       self.loadweather(search: place)
                       }
                   }
               }
            }
       }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error: \(error.localizedDescription)")
        }

    @IBAction func onsearchTapped(_ sender: UIButton) {
        loadweather(search: searchTextField.text)
    }
    
    
    private func loadweather( search : String?){
        
        guard let search = search else{
            
            return
        }
        
        // Step1 : Get URL
        guard let url = getURL(query: search) else{
            
            print("Could not get URL")
            return
        }
        
        //url session
        
        let session = URLSession.shared
        
        //task for session
        
        let dataTask = session.dataTask(with: url){
            
            data, response, error in
            
            print("Network call finished")
            
            guard error == nil else{
                
                print("Error occured")
                return
            }
            
            guard let data = data else{
                
                print("No data found")
                return
            }
          
            if let weatherResponse = self.parseJson(data: data){
                
                print(weatherResponse.location.name)
                print(weatherResponse.current.temp_c)
                
                DispatchQueue.main.async {
                    self.locationLabel.text = weatherResponse.location.name
                    
//
                    if(self.changetemp.isOn){
                        
                   let f =   ( weatherResponse.current.temp_c*1.8)+32
                        
                        self.tempLabel.text = "\(f)F"
                    }
                    else
                    {
                        self.tempLabel.text = "\(weatherResponse.current.temp_c)C"
                    }
                    
                    
//                    self.weatherconditionLabel.text = weatherResponse.climate.text
                }
                
            }
            
        }
        
        //start task
        
        dataTask.resume()
        
    }
    
    
    private func getURL(query: String) -> URL? {
        
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apikey = "aaa198364f724f60878224138232003"
        guard let url = "\(baseUrl)\(currentEndpoint)?key=\(apikey)&q=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else
        {
            return nil
        }
        
        print(url)
        
        return URL(string: url)
    }
    
    private func parseJson(data: Data) -> WeatherResponse? {
        
        let decoder = JSONDecoder()
        var weather : WeatherResponse?
        do{
            weather = try decoder.decode(WeatherResponse.self, from: data)
        }
        catch {
            
            print("Error Decoding")
        }
        
        return weather
        
    }
        
   
}

struct WeatherResponse : Decodable{
    
    let location:Location
    let current: Weather
//    let climate: weathercondition
    
}

struct Location: Decodable{
    
    let name: String
}

struct Weather: Decodable{
    
    let temp_c: Float
   
    
}

   


