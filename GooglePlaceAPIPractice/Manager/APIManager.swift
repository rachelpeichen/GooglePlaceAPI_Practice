//
//  APIManager.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import Foundation
import Alamofire

class APIManager {

  let apiKey = "YourAPIKey"

  static let shared = APIManager()

  func requestPlaceTextSearch(input: String, completion: @escaping (Swift.Result<PlaceTextSearch, Error>) -> Void) {

    let requestURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" + apiKey

    let url = requestURL + "&query=" + input

    guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }

    AF.request(encodedURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in

      switch response.result {

      case .success:
        if let jsonData = response.data {

          do {
            let decoder = JSONDecoder()
            let searchResult: PlaceTextSearch = try decoder.decode(PlaceTextSearch.self, from: jsonData)
            completion(.success(searchResult))

          } catch let DecodingError.dataCorrupted(context) {
            print(context)
            completion(.failure(DecodingError.dataCorrupted(context)))

          } catch let DecodingError.keyNotFound(key, context) {
            print(DecodingError.keyNotFound(key, context))
            completion(.failure(DecodingError.keyNotFound(key, context)))

          } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(DecodingError.valueNotFound(value, context)))

          } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(DecodingError.typeMismatch(type, context)))

          } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            completion(.failure(error))
          }
        }

      case.failure(let error):
        print("Request error: \(error.localizedDescription)")
        completion(.failure(error))
      }
    }
  }

  func requestPlacePhoto(photoRef: String , completion: @escaping ((UIImage) -> Void)) {

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
