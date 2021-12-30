//
//  PhotoModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/28.
//

import Foundation

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
