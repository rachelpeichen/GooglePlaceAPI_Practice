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

  // MARK: IBAction
  @IBAction func changeImagePage(_ sender: UIPageControl) {
    let point = CGPoint(x: collectionVIew.frame.size.width * CGFloat(sender.currentPage), y: 0)
    collectionVIew.setContentOffset(point, animated: true)
  }

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
    fetchPlaceDetails(id: id)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    tableView.separatorStyle = .none
    collectionVIew.isPagingEnabled = true
  }

  // MARK: Functions
  func fetchPlaceDetails(id: String) {

    APIManager.shared.requestPlaceDetails(placeID: id) { result in

      switch result {

      case .success(let details):
        self.placeName = details.result.name
        self.placeAddress = details.result.formattedAddress

        if details.result.photos.count >= 5 {

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

        } else {
          self.alertForApiError(message: "No data to show")
        }

      case .failure(let error):
        self.alertForApiError(message: error.localizedDescription)
      }
    }
  }

  func alertForApiError(message: String) {

    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Try Again", style: .default) { action in
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: UICollectionViewDelegate
extension ResultViewController: UICollectionViewDelegate {
}

// MARK: UICollectionViewDelegateFlowLayout
extension ResultViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
  }
}

// MARK: UICollectionViewDataSource
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

// MARK: UIScrollViewDelegate
extension ResultViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {

    let offSet = scrollView.contentOffset.x
    let width = scrollView.frame.width
    let horizontalCenter = width / 2
    placeImagePageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
  }
}
