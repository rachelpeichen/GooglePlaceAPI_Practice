//
//  PlaceDetail.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/11/23.
//

import Foundation

struct PlaceDetail: Codable {
    let result: Result?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case result
        case status
    }
}
