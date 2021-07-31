//
//  ViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/30.
//

import UIKit

class ViewController: UIViewController {

  // MARK: Outlet
  @IBOutlet weak var searchBar: UISearchBar!

  // MARK: Properties
  var searchController = UISearchController()
  var resultViewController = ResultViewController()
  var placeID: String?

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    searchBar.delegate = self
  }

  // MARK: Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let resultVC = segue.destination as? ResultViewController {
      guard let id = placeID else { return }
      resultVC.placeID = id
    }
  }

  func alertForSearchError(message: String) {

    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Try Again", style: .default) { action in
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}

extension ViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    guard let text = searchBar.text else { return }

    APIManager.shared.requestPlaceId(input: text) { result in

      switch result {

      case .success(let placeID):
        if !placeID.candidates.isEmpty {
          self.placeID = placeID.candidates[0].placeID
          self.performSegue(withIdentifier: "NavigateToResultVC", sender: self)
          searchBar.text = ""

        } else {
          self.alertForSearchError(message: placeID.status)
        }

      case .failure(let error):
        self.alertForSearchError(message: error.localizedDescription)
      }
    }
  }
}
