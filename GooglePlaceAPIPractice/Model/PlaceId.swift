//
//  PlaceId.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import Foundation

struct PlaceID: Codable {
  let candidates: [Candidate]
  let status: String
}

struct Candidate: Codable {
  let placeID: String

  enum CodingKeys: String, CodingKey {
    case placeID = "place_id"
  }
}
