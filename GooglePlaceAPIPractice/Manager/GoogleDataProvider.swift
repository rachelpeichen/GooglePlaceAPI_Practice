// Wrapper class for making Google API calls

import UIKit
import CoreLocation
import Alamofire

typealias NearbyCompletion = (NearbySearch) -> Void
typealias DetailCompletion = (PlaceDetail) -> Void
typealias ErrorHandler = (Error) -> Void

class GoogleDataProvider {
    
    static let shared = GoogleDataProvider()
    
    func searchNearbyPlaces(near coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping NearbyCompletion, onError: @escaping ErrorHandler) {
#warning("包裝url")
        var urlString = APIurl.nearbySearch + "location=\(coordinate.latitude),\(coordinate.longitude)" + "&radius=\(radius)" + "&keyword=coffee" + "&key=\(googleApiKey)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
#warning("設計api架構")
        AF.request(urlString, method: .get).validate(statusCode: 200..<299).responseDecodable(of: NearbySearch.self) { response in
            
            switch response.result {
            case .success(let data):
                completion(data)
                
            case .failure(let error):
                onError(error)
                guard let urlError = error.underlyingError as? URLError else { return }
                switch urlError.code {
                case .timedOut:
                    print(urlError)
                case .notConnectedToInternet:
                    print(urlError)
                default:
                    print(urlError)
                }
            }
        }
    }
    
    func fetchPlaceDetail(placeID: String, completion: @escaping DetailCompletion, onError: @escaping ErrorHandler) {
        var urlString = APIurl.placeDetail + "place_id=" + placeID + "&key=\(googleApiKey)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        AF.request(urlString, method: .get).validate(statusCode: 200..<299).responseDecodable(of: PlaceDetail.self) { response in
            
            switch response.result {
            case .success(let data):
                completion(data)
                
            case .failure(let error):
                onError(error)
                guard let urlError = error.underlyingError as? URLError else { return }
                switch urlError.code {
                case .timedOut:
                    print(urlError)
                case .notConnectedToInternet:
                    print(urlError)
                default:
                    print(urlError)
                }
            }
        }
    }
}
