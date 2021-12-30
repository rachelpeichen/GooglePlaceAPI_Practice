//
//  GoogleMapViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/11/22.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            // to update the mapview camera view smoothly after we get the location
            guard let myLocationCoordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            mapView.camera = GMSCameraPosition.camera(withTarget: myLocationCoordinate, zoom: 15.0)
            fetchNearbyPlaces(near: myLocationCoordinate)
        }
    }
    
    // MARK: - Properties
    
    private let viewModel = GoogleMapViewModel()
    let locationManager = CLLocationManager()
    let searchRadius: Double = 1000
    var placeID: String?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layoutView()
        bindNearbyPlaces()
        
        #warning("為啥這些一定要有不然crash?")
        if CLLocationManager.locationServicesEnabled() {
            // receive a one-time location update
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Functions
    
    func layoutView() {
        locationManager.delegate = self
        mapView.delegate = self
    }
    
    func bindNearbyPlaces() {
        viewModel.nearbyPlaces.bind { [weak self] nearbyPlaces in
            guard let nearbyPlaces = nearbyPlaces else { return }
            nearbyPlaces.results.forEach { place in
                let marker = PlaceMarker(place: place)
                marker.map = self?.mapView
            }
        }

        viewModel.onNearbySearchError = { error in
            print(error)
        }
    }
    
    func fetchNearbyPlaces(near coordinate: CLLocationCoordinate2D) {
        viewModel.fetchNearbyPlaces(near: coordinate, radius: searchRadius)
    }
}

// MARK: - CLLocationManagerDelegate

extension GoogleMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
#warning("確認如何handle如果用戶拒絕定位")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        case .denied, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location Auth Restricted")
        @unknown default:
            print("Unknown Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // receive a single location update
        guard (locations.last?.coordinate) != nil else { return }
        let concurrentQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent)
        
        concurrentQueue.async {
            self.fetchNearbyPlaces(near: self.mapView.camera.target)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else { return nil }
        guard let infoView = UIView.fromNib(named: "MarkerInfoView") as? MarkerInfoView else { return nil }
        infoView.nameLabel.text = placeMarker.place.name
        infoView.isUserInteractionEnabled = true
        return infoView
    }
    
    // 現在有這個就不會顯示infowindow
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        guard let placeMarker = marker as? PlaceMarker else { return  false }
//        print("tap \(placeMarker.place.name)")
//        return true
//    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let placeMarker = marker as? PlaceMarker else { return }
        guard let placeID = placeMarker.place.placeID else { return }
        let placeDetailVC = PlaceDetailViewController.initialize(placeDetailViewModel: PlaceDetailViewModel(placeID: placeID))
        self.navigationController?.pushViewController(placeDetailVC, animated: true)
    }
}
