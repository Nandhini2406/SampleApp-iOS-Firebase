//
//  GoogleMapsScreen.swift
//  SampleApp
//
//  Created by DoodleBlue on 13/07/23.
//

import UIKit
import CoreLocation
import GoogleMaps
import ANLoader

class GoogleMapsScreen: UIViewController, CLLocationManagerDelegate {
    
    
    var viewModel: ViewModel = ViewModel()
        let managerLocation = CLLocationManager()
    
    let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            ANLoader.hide()
        }
    
        override func viewWillAppear(_ animated: Bool) {
            ANLoader.showLoading("Loading", disableUI: true)
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let apiKey = keyForApi
            GMSServices.provideAPIKey(apiKey)
            
            viewModel.delegate = self
            setUpMap()
            
            managerLocation.delegate = self
            managerLocation.requestWhenInUseAuthorization()
            managerLocation.startUpdatingLocation()
        }
    
    
    func setUpMap()  {
        
        self.navigationController?.isNavigationBarHidden = false
        
            let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
            let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            self.view.addSubview(mapView)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
        }
    
    
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            viewModel.updateLocations(locations)
        }
    }

    extension GoogleMapsScreen: ViewModelDelegate {
        func didUpdateMapView(with mapView: GMSMapView) {
            self.view.addSubview(mapView)
        }
        
        func didUpdateMarker(with marker: GMSMarker) {
            marker.map = viewModel.mapView
        }
    }
    


