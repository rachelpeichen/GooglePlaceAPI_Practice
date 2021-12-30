//
//  GeometryModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/28.
//

import Foundation

struct Geometry: Codable {
    let location: Location?
    let viewport: Viewport?
}

struct Location: Codable {
    let lat, lng: Double?
}

struct Viewport: Codable {
    let northeast, southwest: Location?
}
