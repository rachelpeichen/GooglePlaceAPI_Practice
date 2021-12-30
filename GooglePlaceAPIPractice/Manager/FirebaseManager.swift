//
//  FirebaseManager.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/29.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    typealias SavePlaceCompletion = () -> Void
    typealias FetchSavedPlacesCompletion = ([String]) -> Void
    var collection: [String] = []
    
    let database = Firestore.firestore()
    
    func savePlace(placeID: String, completion: @escaping SavePlaceCompletion) {
        database.collection("SavedPlaces").document().setData(["placeID" : placeID]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                completion()
                print("Document successfully written!")
            }
        }
    }
    
    func fetchSavedPlaces(completion: @escaping FetchSavedPlacesCompletion) {
        database.collection("SavedPlaces").getDocuments() { querySnapshot, error in
            if let error = error {
                print(error)
            } else {
                for doc in querySnapshot!.documents {
                    let placeIDdic = doc.data()
                    self.collection.append(placeIDdic["placeID"] as! String)
                }
                completion(self.collection)
                // 要清掉不然會一直存進ㄑ 有更好的做法吧？
                self.collection.removeAll()
            }
        }
    }
}
