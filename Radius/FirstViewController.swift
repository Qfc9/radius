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

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager();
    @IBOutlet weak var Lat: UILabel!
    @IBOutlet weak var Lon: UILabel!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        Lat.text = String(location.coordinate.latitude)
        Lon.text = String(location.coordinate.longitude)
        
        print(location.coordinate)
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

