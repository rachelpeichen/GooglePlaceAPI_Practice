//
//  PlaceDetails.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import Foundation

struct PlaceDetails: Codable {
  let result: Result
  let status: String
}

struct Result: Codable {
  let formattedAddress: String
  let name: String
  let photos: [Photo]

  enum CodingKeys: String, CodingKey {
    case formattedAddress = "formatted_address"
    case name
    case photos
  }
}

struct Photo: Codable {
  let height: Int
  let htmlAttributions: [String]
  let photoReference: String
  let width: Int

  enum CodingKeys: String, CodingKey {
    case height
    case htmlAttributions = "html_attributions"
    case photoReference = "photo_reference"
    case width
  }
}
