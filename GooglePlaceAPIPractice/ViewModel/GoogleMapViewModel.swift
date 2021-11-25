//
//  GoogleMapViewModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/11/23.
//

import Foundation
import CoreLocation

class GoogleMapViewModel {

    let nearbyPlaces: Box<[PlacesNearbySearch]?> = Box(nil) // no places initially
    var onError: ((Error) -> Void)?
    
    func fetchNearbyPlaces(near coordinate: CLLocationCoordinate2D, radius: Double) {
        GoogleDataProvider.shared.fetchPlaces(near: coordinate, radius: radius) { [weak self] places in
            self?.nearbyPlaces.value = places
        } onError: { error in
            self.onError?(error)
        }
    }
}
