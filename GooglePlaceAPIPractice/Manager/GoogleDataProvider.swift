// Wrapper class for making Google API calls

import UIKit
import CoreLocation

typealias PlacesCompletion = ([PlacesNearbySearch]) -> Void
typealias PlaceDetailCompletion = (PlacesNearbySearch) -> Void
typealias ErrorHandler = (Error) -> Void
//typealias PhotoCompletion = (UIImage?) -> Void // unuse now

class GoogleDataProvider {
    
    static let shared = GoogleDataProvider()
//    private var photosDictionary: [String: UIImage] = [:] // unuse now
    private var placesTask: URLSessionDataTask?
    private var session: URLSession { return URLSession.shared }
    
    func fetchPlaces(near coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping PlacesCompletion, onError: @escaping ErrorHandler) {
        // MARK: - 包裝url string
        var urlString = APIurl.nearbySearch + "location=\(coordinate.latitude),\(coordinate.longitude)" + "&radius=\(radius)" + "&keyword=coffee" + "&key=\(googleApiKey)"
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        
        
        
        placesTask = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                onError(error)
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let placesResponse = try? decoder.decode(PlacesNearbySearch.Response.self, from: data) else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            if let errorMessage = placesResponse.errorMessage {
                print(errorMessage)
            }
            
            DispatchQueue.main.async {
                completion(placesResponse.results)
            }
        }
        placesTask?.resume()
    }
    
    func fetchPlaceDetail(placeID: String, completion: @escaping PlaceDetailCompletion, onError: @escaping ErrorHandler) {
        var urlString = APIurl.placeDetail + "place_id=" + placeID
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        let url = URL(string: urlString)
        print(url)
        // guard let url = URL(string: urlString) else { return }
        
        //  現在會跳到 task.cancel
//        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
//            task.cancel()
//        }
        
        placesTask = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                onError(error)
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let placesResponse = try? decoder.decode(PlacesNearbySearch.Response.self, from: data) else { return }
            
            if let errorMessage = placesResponse.errorMessage {
                print(errorMessage)
            }
            
            DispatchQueue.main.async {
                  completion(placesResponse.results[0])
            }
        }
        placesTask?.resume()
    }
}
