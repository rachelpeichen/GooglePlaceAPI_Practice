//
//  ResultViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import UIKit

class ResultViewController: UIViewController {

  // MARK: IBOutlets
  @IBOutlet weak var collectionVIew: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var placeImagePageControl: UIPageControl!

  // MARK: Properties
  var placeID: String?
  var photoReference: [String] = []
  var photoUIImage: [UIImage] = []
  var placeName: String?
  var placeAddress: String?

  // MARK: View Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    guard let id = placeID else { return }

    APIManager.shared.requestPlaceDetails(placeID: id) { result in

      switch result {

      case .success(let details):
        self.placeName = details.result.name
        self.placeAddress = details.result.formattedAddress

        let dispatchGroup = DispatchGroup()

        for i in 0..<5 {
          dispatchGroup.enter()
          let photoRef = details.result.photos[i].photoReference
          self.photoReference.append(photoRef)
          dispatchGroup.leave()
        }

        for i in 0..<5 {
          dispatchGroup.enter()
          APIManager.shared.requestPlacePhotos(photoRef: self.photoReference[i]) { image in
            self.photoUIImage.append(image)
            dispatchGroup.leave()
          }
        }

        dispatchGroup.notify(queue: .main) {
          self.tableView.reloadData()
          self.collectionVIew.reloadData()
        }

      case .failure(let error):
        self.alertForApiError(message: error.localizedDescription)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    tableView.separatorStyle = .none
  }

  // MARK: Functions
  func alertForApiError(message: String) {

    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Try Again", style: .default) { action in
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}


extension ResultViewController: UICollectionViewDelegate {
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
  }
}

extension ResultViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionViewCell {

      if !photoUIImage.isEmpty {
        cell.placeImage.image = photoUIImage[indexPath.row]
      }

      return cell
    }
    return CollectionViewCell()
  }
}

// MARK: UITableViewDelegate
extension ResultViewController: UITableViewDelegate {
}

// MARK: UITableViewDataSource
extension ResultViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as? TableViewCell {

      cell.layoutTableCell(name: placeName ?? "Name", address: placeAddress ?? "Address")

      if !photoUIImage.isEmpty {
        cell.placeImage.image = photoUIImage[0]
      }

      return cell
    }
    return TableViewCell()
  }
}
