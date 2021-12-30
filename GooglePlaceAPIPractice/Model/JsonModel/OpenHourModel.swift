//
//  OpenHourModel.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/28.
//

import Foundation

struct OpeningHours: Codable {
    let openNow: Bool?
    let periods: [OpeningHoursPeriod]?
    let weekdayText: [String]?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case periods
        case weekdayText = "weekdat_text"
    }
}

struct OpeningHoursPeriod: Codable {
    let close: OpeningHoursPeriodDetail
    let open: OpeningHoursPeriodDetail
}

struct OpeningHoursPeriodDetail: Codable {
    let day: Int
    let time: String
}
