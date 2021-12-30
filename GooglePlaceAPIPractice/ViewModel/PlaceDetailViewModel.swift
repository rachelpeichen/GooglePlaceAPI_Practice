//
//  PlaceDetailViewModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/29.
//

import Foundation

class PlaceDetailViewModel {
    
    let placeID: String
    var placeDetail: Observer<PlaceDetail?> = Observer(nil)
    var onPlaceDetailError: ((Error) -> Void)?
    
    init(placeID: String) {
        self.placeID = placeID
    }
    
    func fetchPlaceDetail() {
        GoogleDataProvider.shared.fetchPlaceDetail(placeID: placeID) { detail in
            self.placeDetail.value = detail
        } onError: { error in
            self.onPlaceDetailError?(error)
        }
    }
    
    func savePlace() {
        FirebaseManager.shared.savePlace(placeID: placeID) {
            // 成功 save
        }
    }
}
