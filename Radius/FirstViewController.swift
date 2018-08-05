//
//  FirstViewController.swift
//  Radius
//
//  Created by Elijah Harmon on 7/30/18.
//  Copyright © 2018 Rainy Vibes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    var count = 0
    @IBOutlet weak var Lat: UILabel!
    @IBOutlet weak var Lon: UILabel!
    @IBOutlet weak var Results: UILabel!
    @IBAction func DiscoverBTN(_ sender: Any) {
        get_nearby(latitude: (manager.location?.coordinate.latitude.description)!, longitude: (manager.location?.coordinate.longitude.description)!)
    }
    
    @IBAction func CreateBTN(_ sender: Any) {
        post_gps(latitude: Double((manager.location?.coordinate.latitude)!), longitude: Double((manager.location?.coordinate.longitude)!))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        Lat.text = String(location.coordinate.latitude)
        Lon.text = String(location.coordinate.longitude)
        Results.text = String(count)
        
//        print(location.coordinate)
//        post_gps(latitude:location.coordinate.latitude, longitude:location.coordinate.longitude)
    }
    
    func get_nearby(latitude: String, longitude: String) {
        print(latitude, longitude)
        let url = URL(string: "https://secretservice.app/get_nearby?latitude=\(latitude)&longitude=\(longitude)")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    let count = (jsonSerialized?["count"])! as? Int
                    self.count = count!
//                    print(count)
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        print(url)
                        print(explanation)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func post_gps(latitude: Double, longitude: Double) {
        let url = URL(string: "https://secretservice.app/basic.php?lat=\(latitude)&lon=\(longitude)")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        print(url)
                        print(explanation)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

