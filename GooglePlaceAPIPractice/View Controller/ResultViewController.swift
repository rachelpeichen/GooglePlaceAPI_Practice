//
//  ResultViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import UIKit

class ResultViewController: UIViewController {

  // MARK: IBOutlet
  @IBOutlet weak var collectionVIew: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var placeImagePageControl: UIPageControl!

  // MARK: IBAction
  @IBAction func changeImagePage(_ sender: UIPageControl) {

    let point = CGPoint(x: collectionVIew.frame.size.width * CGFloat(sender.currentPage), y: 0)
    collectionVIew.setContentOffset(point, animated: true)
  }

  // MARK: Properties
  var searchResult: PlaceTextSearch?

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    tableView.separatorStyle = .none
    collectionVIew.isPagingEnabled = true

    guard let searchResult = searchResult else { return}

    if searchResult.results.count < 5 {
      self.alertForApiError(message: "No enough photos to show")
    }
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

      guard let searchResult = searchResult else { return CollectionViewCell() }

      if searchResult.results.count >= 5 {

        if let photo = searchResult.results[indexPath.row].photos {

          APIManager.shared.requestPlacePhoto(photoRef: photo[0].photoReference) { image in

            DispatchQueue.main.async {
              cell.placeImage.image = image
            }
          }
        }

      } else {

        if let photo = searchResult.results[0].photos {

          APIManager.shared.requestPlacePhoto(photoRef: photo[0].photoReference) { image in

            DispatchQueue.main.async {
              cell.placeImage.image = image
            }
          }
        }
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
    return searchResult?.results.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as? TableViewCell {

      guard let searchResult = searchResult else { return TableViewCell() }

      let name = searchResult.results[indexPath.row].name
      let address = searchResult.results[indexPath.row].formattedAddress

      cell.layoutTableCell(name: name, address: address)

      if let photo = searchResult.results[indexPath.row].photos {

        APIManager.shared.requestPlacePhoto(photoRef: photo[0].photoReference) { image in

          DispatchQueue.main.async {
            cell.placeImage.image = image
          }
        }
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
