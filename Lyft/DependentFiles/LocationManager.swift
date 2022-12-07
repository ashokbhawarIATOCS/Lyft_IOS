//
//  LocationService.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let instance = LocationManager()

    var locationManager = CLLocationManager()

    private override init() {
        super.init()
        
    }
    
    func startup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            UserDefaults.standard.set(String(format: "%.6f", latitude), forKey: "lastKnownLatitude")
            UserDefaults.standard.set(String(format: "%.6f", longitude), forKey: "lastKnownLongitude")
            getAddressFromLatLon(pdblLatitude: String(latitude), withLongitude: String(longitude))
            print("Location latitude \(latitude) \nLocation longitude \(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error \(error.localizedDescription)")
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country as Any)
                    print(pm.locality as Any)
                    print(pm.subLocality as Any)
                    print(pm.thoroughfare as Any)
                    print(pm.postalCode as Any)
                    print(pm.subThoroughfare as Any)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print(addressString)
                    UserDefaults.standard.set(addressString, forKey: "FinalAddress")
              }
        })
    }
}
