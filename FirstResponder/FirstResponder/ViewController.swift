//
//  ViewController.swift
//  FirstResponder
//
//  Created by Jonas Deichelmann on 03.11.17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import TB
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var longtitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        var helloWorldTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.location(_:)), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
    }

    @IBAction func location(_ sender: Any) {
        locationManager.startUpdatingLocation()
        let loc = locationManager.location
        let lat = (loc?.coordinate.latitude)!
        let long = (loc?.coordinate.longitude)!
        latitude.text = String(lat)
        longtitude.text = String(long)
        let parameters: [String: Any] = [
            "key" : "03afc455-5170-42af-b83e-6b65358c0bea",
            "userID" : 1,
            "coordination":[
                "Latitude" : lat,
                "Longtituge": long,
            ],
            "currentDate" : String(describing: Date())
            ]
        TB.temp("\(parameters)")
        Alamofire.request("http://174.129.62.164/api/smile/", method: .post, parameters: parameters)
            .responseString { response in
                print(response)
        }

    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            TB.info("If status has not yet been determied, ask for authorization")
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            TB.info("If authorized when in use")
//            locationManager.startUpdatingLocation()
//            let loc = locationManager.location
//            let lat = (loc?.coordinate.latitude)!
//            let long = (loc?.coordinate.longitude)!
            break
        case .authorizedAlways:
            TB.info("If always authorized")
            break
        case .restricted:
            TB.info("If restricted by e.g. parental controls. User can't enable Location Services")
            break
        case .denied:
            TB.info("If user denied your app access to Location Services, but can grant access from Settings.app")
            break
        }
    }

}

