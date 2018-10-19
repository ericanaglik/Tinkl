//
//  MapScreen.swift
//  Tinkl
//
//  Created by Erica Naglik and Anwar M. Azeez on 10/13/18.
//  Copyright © 2018 Zelik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// establishes the pin used to mark toilets on the map
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

// establishes the map
class MapScreen: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    // determines how far the map zooms in to the users location when the app is open
    let regionInMeters: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // determines whether or not the user allowed location services for the app
        checkLocationServices()
        
        // establishes latitude and longitude of location 1
        let location = CLLocationCoordinate2D(latitude: 37.787683, longitude: -122.41094)
        //creates a pin for location 1
        let pin = customPin(pinTitle: "Private Bathroom", pinSubTitle: "555 Post Street", location: location)
        // places the pin for location 1 on the map
        self.mapView.addAnnotation(pin)
        self.mapView.delegate = self
        
        // establishes latitude and longitude of location 2
        let location2 = CLLocationCoordinate2D(latitude: 37.789059, longitude: -122.40763)
        //creates a pin for location 2
        let pin2 = customPin(pinTitle: "McDonald's Bathroom", pinSubTitle: "441 Sutter St", location: location2)
        
        // places the pin for location 2 on the map
        self.mapView.addAnnotation(pin2)
        self.mapView.delegate = self
        
        // establishes latitude and longitude of location 3
        let location3 = CLLocationCoordinate2D(latitude: 37.787365, longitude: -122.4059)
        //creates a pin for location 3
        let pin3 = customPin(pinTitle: "Neiman Marcus Bathroom", pinSubTitle: "150 Stockton St", location: location3)
        // places the pin for location 3 on the map
        self.mapView.addAnnotation(pin3)
        self.mapView.delegate = self
        
        // establishes latitude and longitude of location 4
        let location4 = CLLocationCoordinate2D(latitude: 37.783947, longitude: -122.40715)
        //creates a pin for location 4
        let pin4 = customPin(pinTitle: "Westfield San Francisco Shopping Center Bathroom", pinSubTitle: "865 Market St", location: location4)
        // places the pin for location 4 on the map
        self.mapView.addAnnotation(pin4)
        self.mapView.delegate = self
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        // makes the pin into the toilet image
        annotationView.image = UIImage(named:"pin.png")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("annotation title == \(String(describing: view.annotation?.title!))")
    }
    
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // centers on the user location when the app is opened
    func centerViewOnUserLocation() {
        // sets the location to the users current location
        if let location = locationManager.location?.coordinate {
            // sets the region to the users current region
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    

    
    // checks to see if location services is enabled for the app
    func checkLocationServices() {
        // if location services is enabled, grab the users location and use it
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
}


extension MapScreen: CLLocationManagerDelegate {
    // setup the location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    // check location services authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


