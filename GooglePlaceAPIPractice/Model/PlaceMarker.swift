//
//  PlaceMarker.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/11/22.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: Result
    
    init(place: Result) {
        self.place = place
        super.init()
        
        guard let lat = place.geometry?.location?.lat else { return }
        guard let lng = place.geometry?.location?.lng else { return }
        
        self.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.icon = UIImage(named: "cafe_pin")
        // self.title = "test" 這個現在沒用
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .none
    }
}
