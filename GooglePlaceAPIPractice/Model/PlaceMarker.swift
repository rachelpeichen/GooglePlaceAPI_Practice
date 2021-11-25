//
//  PlaceMarker.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/11/22.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: PlacesNearbySearch

    init(place: PlacesNearbySearch) {
      self.place = place
      super.init()

      position = place.coordinate
      groundAnchor = CGPoint(x: 0.5, y: 1)
      appearAnimation = .pop

      icon = UIImage(named: "cafe_pin")
    }
}
