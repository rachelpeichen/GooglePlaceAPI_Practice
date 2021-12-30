//
//  GoogleMapViewModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/11/23.
//

import Foundation
import CoreLocation

class GoogleMapViewModel {
    
    var nearbyPlaces: Observer<NearbySearch?> = Observer(nil) // no places initially
    var onNearbySearchError: ((Error) -> Void)?

    func fetchNearbyPlaces(near coordinate: CLLocationCoordinate2D, radius: Double) {
        GoogleDataProvider.shared.searchNearbyPlaces(near: coordinate, radius: radius) { nearbyPlaces in
            self.nearbyPlaces.value = nearbyPlaces
        } onError: { error in
            self.onNearbySearchError?(error)
        }
    }
}
