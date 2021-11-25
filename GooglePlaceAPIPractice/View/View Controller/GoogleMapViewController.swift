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
    
    private let viewModel = GoogleMapViewModel()
    let locationManager = CLLocationManager()
    let searchRadius: Double = 1000
    var placeID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        mapView.delegate = self
        
        // MARK: - TODO: 為啥這些一定要有不然crash?
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
    func fetchNearbyPlaces(near coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        viewModel.fetchNearbyPlaces(near: coordinate, radius: searchRadius)
        
        viewModel.nearbyPlaces.bind { places in
            places?.forEach { place in
                let marker = PlaceMarker(place: place)
                marker.map = self.mapView
                print(place)
            }
        }
        
        GoogleDataProvider.shared.fetchPlaceDetail(placeID: "ChIJOW18SSeoQjQRrtUr7PJEgbA") { place in
            print(place)
        } onError: { err in
            print(err)
        }

        
        viewModel.onError = { error in
            print(error.localizedDescription)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension GoogleMapViewController: CLLocationManagerDelegate {
    // 這個應該也要才對，用來處理是否接受開啟？
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // MARK: - TODO: 確認如何handle如果用戶拒絕
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
        //        guard let location = locations.first else { return }
        //
        //        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // receive a single location update
        // guard let coordinate = locations.last?.coordinate else { return }
//        let concurrentQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent)

//         concurrentQueue.async {
//            self.fetchNearbyPlaces(near: self.mapView.camera.target)
//         }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else { return nil }

        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else { return nil }

        infoView.nameLabel.text = placeMarker.place.name
        infoView.addressLabel.text = placeMarker.place.address

        return infoView
    }
    
    // MARK: 這邊看 https://www.raywenderlich.com/7363101-google-maps-ios-sdk-tutorial-getting-started tidying ui
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // 好像有這個就不會有infowindow?
        let myFirstButton = UIButton()
        myFirstButton.setTitle("✸", for: .normal)
        myFirstButton.setTitleColor(UIColor.blue, for: .normal)
        myFirstButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
//        myFirstButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)

        self.view.addSubview(myFirstButton)
      return true
    }
    
    
//    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!)
}

