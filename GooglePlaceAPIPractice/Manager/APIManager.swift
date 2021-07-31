//
//  APIManager.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import Foundation
import Alamofire

class APIManager {

  let apiKey = "MyApiKey"

  static let shared = APIManager()

  func requestPlaceId(input: String, completion: @escaping ((PlaceID) -> Void)) {

    let requestURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=" + apiKey

    let url = requestURL + "&input=" + input + "&inputtype=textquery"

    guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return } // 沒有encode時url會invalid因為有帶入input

    AF.request(encodedURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in

      switch response.result {

      case .success:

        if let jsonData = response.data {

          do {

            let decoder = JSONDecoder()
            let placeIDdata: PlaceID = try decoder.decode(PlaceID.self, from: jsonData)
            completion(placeIDdata)

          } catch let DecodingError.dataCorrupted(context) {
            print(context)

          } catch let DecodingError.keyNotFound(key, context) {
            print(DecodingError.keyNotFound(key, context))

          } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)

          } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)

          } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
          }
        }

      case.failure(let error):
        print("Request error: \(error.localizedDescription)")
      }
    }
  }

  func requestPlaceDetails(placeID: String, completion: @escaping (Swift.Result<PlaceDetails, Error>) -> Void) {

    let requestURL = "https://maps.googleapis.com/maps/api/place/details/json?key=" + apiKey

    let url = requestURL + "&place_id=" + placeID

    guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }

    AF.request(encodedURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in

      switch response.result {

      case .success:

        if let jsonData = response.data {

          do {

            let decoder = JSONDecoder()
            let detailsData: PlaceDetails = try decoder.decode(PlaceDetails.self, from: jsonData)
            completion(.success(detailsData))

          } catch let DecodingError.dataCorrupted(context) {
            print(context)

          } catch let DecodingError.keyNotFound(key, context) {
            print(DecodingError.keyNotFound(key, context))

          } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)

          } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)

          } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
          }
        }

      case.failure(let error):
        print("Request error: \(error.localizedDescription)")
        completion(.failure(error))
      }
    }
  }

  func requestPlacePhotos(photoRef: String , completion: @escaping ((UIImage) -> Void)) {

    let requestURL = "https://maps.googleapis.com/maps/api/place/photo?key=" + apiKey

    let url = URL(string: requestURL + "&photoreference=" + photoRef + "&maxheight=300")

    guard let photoURL = url else { return }

    let request = URLRequest(url: photoURL)

    let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

      if let error = error {
        print(error.localizedDescription)
        
      } else if let data = data {

        if let photo = UIImage(data: data) {
          completion(photo)
        }
      }
    }
    dataTask.resume()
  }
}
