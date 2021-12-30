//
//  CollectionViewModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/29.
//

import Foundation

class CollectionViewModel {
    
    var onFetchSavedPlaces: (([String]) -> Void)?
    // 這個跟place detail view model 重複
    var savedPlacesDetail: Observer<PlaceDetail?> = Observer(nil)
    var onSavedPlaceDetailError: ((Error) -> Void)?
    
    func fetchSavedPlaces() {
        FirebaseManager.shared.fetchSavedPlaces { placesID in
            self.onFetchSavedPlaces?(placesID)
        }
    }
    
    // 這個跟place detail view model 重複
    func fetchPlaceDetail(placeID: String) {
        GoogleDataProvider.shared.fetchPlaceDetail(placeID: placeID) { placeDetail in
            self.savedPlacesDetail.value = placeDetail
        } onError: { error in
            self.onSavedPlaceDetailError?(error)
        }
    }
}
