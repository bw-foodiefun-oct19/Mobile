//
//  SearchViewController.swift
//  FoodieFun
//
//  Created by Casualty on 10/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Searched String
    var searchedTextString: String = ""
    
    // Array of searched results
    var arrayOfResutls: [MKMapItem] = []
    
    // Initial locations
    var userCurrentLocation = CLLocation(latitude: 0,
                                     longitude:0)
    // Location manager
    var locationManager:CLLocationManager!
    
    // Search radius
    let searchRadius: CLLocationDistance = 10000
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSetup()
        searchBar.delegate = self
        searchBar.showsSearchResultsButton = true
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    
    // Search button on keyboard clicked
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        if let searchedText: String = searchBar.text {
            mapView.removeAnnotations(mapView.annotations)
            searchedTextString = searchedText
            searchInMap()
            
            searchBar.resignFirstResponder()
        }
    }
    
    // Search in map using given string from searchBar
    func searchInMap() {
        
        // Create request
        let request = MKLocalSearch.Request()
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant])
        request.naturalLanguageQuery = searchedTextString
        
        // Create span
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: userCurrentLocation.coordinate,
                                            span: span)
        // Run search
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name,
                                     latitude: item.placemark.location!.coordinate.latitude,
                                     longitude: item.placemark.location!.coordinate.longitude)
                self.arrayOfResutls.append(item)
                print("\(self.arrayOfResutls)")
                
            }
        })
    }
    
    // Add pins of results to map
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            
            // need to add button to detail disclosure on annotation
            // let btn = UIButton(type: .detailDisclosure)
            annotation.coordinate = location
            annotation.title = title
            mapView.addAnnotation(annotation)
        }
    }
    
    // Map setup
    func mapSetup() {
        mapView.delegate = self
        let coordinateRegion = MKCoordinateRegion.init(center: userCurrentLocation.coordinate,
                                                       latitudinalMeters: searchRadius * 2.0,
                                                       longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(coordinateRegion,
                          animated: true)
        

    }

    // Determine Current Location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    // Location manager to set userLocation, center, and region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Set userLocation
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Set center
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        // Set region attritbutes
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        
        // Set region on mapview
        self.mapView.setRegion(region, animated: true)
        
        manager.stopUpdatingLocation()
        
        // Set coordinates to userCurrentLocation
        userCurrentLocation = CLLocation(latitude: userLocation.coordinate.latitude,
                                         longitude: userLocation.coordinate.longitude)
        
        print("\(userCurrentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

}


