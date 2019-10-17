//
//  SearchViewController.swift
//  FoodieFun
//
//  Created by Casualty on 10/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Searched String
    var searchedTextString: String = ""
    
    // Array of searched results
    var arrayOfResutls: [MKMapItem] = []
    
    // Initial locations
    let initialLocation = CLLocation(latitude: 30.324182,
                                     longitude:-81.660277)
    
    // Search radius
    let searchRadius: CLLocationDistance = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSetup()
        searchBar.delegate = self
        searchBar.showsSearchResultsButton = true
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
        request.region = MKCoordinateRegion(center: initialLocation.coordinate,
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
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate,
                                                       latitudinalMeters: searchRadius * 2.0,
                                                       longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        

    }

}


