//
//  ResultModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/28.
//

import Foundation

struct Result: Codable {
    let businessStatus: BusinessStatus?
    let geometry: Geometry?
    let name: String?
    let openingHours: OpeningHours?
    let photos: [Photo]?
    let placeID: String?
    let priceLevel: Int?
    let rating: Double?
    let reference: String?
    let userRatingsTotal: Int?
    let vicinity: String?
    let permanentlyClosed: Bool?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry
        case name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case priceLevel = "price_level"
        case rating
        case reference
        case userRatingsTotal = "user_ratings_total"
        case vicinity
        case permanentlyClosed = "permanently_closed"
    }
}

enum BusinessStatus: String, Codable {
    case closedTemporarily = "CLOSED_TEMPORARILY"
    case closedPermanently = "CLOSED_PERMANENTLY"
    case operational = "OPERATIONAL"
}
