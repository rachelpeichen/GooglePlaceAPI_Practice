//
//  PlaceTextSearch.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import Foundation

struct PlaceTextSearch: Codable {
  let nextPageToken: String?
  let results: [Result]
  let status: String

  enum CodingKeys: String, CodingKey {
    case nextPageToken = "next_page_token"
    case results
    case status
  }
}

struct Result: Codable {
  let formattedAddress: String
  let name: String
  let photos: [Photo]?
  let placeID: String
  let rating: Double

  enum CodingKeys: String, CodingKey {
    case formattedAddress = "formatted_address"
    case name
    case photos
    case placeID = "place_id"
    case rating
  }
}

struct Photo: Codable {
  let photoReference: String
  let height: Int
  let width: Int

  enum CodingKeys: String, CodingKey {
    case photoReference = "photo_reference"
    case height
    case width
  }
}
