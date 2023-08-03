//
//  ViewModel.swift
//  SampleApp
//
//  Created by DoodleBlue on 13/07/23.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol ViewModelDelegate: AnyObject {
    func didUpdateMapView(with mapView: GMSMapView)
    func didUpdateMarker(with marker: GMSMarker)
}

class ViewModel {
    weak var delegate: ViewModelDelegate?
    var mapView: GMSMapView?

    func updateLocations(_ locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 5.5)
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 13, y: 70, width: UIScreen.main.bounds.width, height: 400), camera: camera)
  // height: UIScreen.main.bounds.height
             
        delegate?.didUpdateMapView(with: mapView!)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        delegate?.didUpdateMarker(with: marker)
    }
}




