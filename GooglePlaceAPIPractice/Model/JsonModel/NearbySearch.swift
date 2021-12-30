//
//  NearbySearchResponse.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let placesTextSearch = try? newJSONDecoder().decode(PlacesTextSearch.self, from: jsonData)

import Foundation

struct NearbySearch: Codable {
    let nextPageToken: String?
    let results: [Result]
    let status: String?

    enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case results
        case status
    }
}
