//
//  ViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/30.
//

import UIKit

class ViewController: UIViewController {

  // MARK: IBOutlet
  @IBOutlet weak var searchBar: UISearchBar!

  // MARK: IBAction
  @IBAction func btnPressed(_ sender: UIButton) {
    searchBar.text = sender.currentTitle

    if let input = sender.currentTitle {
      requestPlaceID(input: input)
    }
  }

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

  func requestPlaceID(input: String) {

    APIManager.shared.requestPlaceID(input: input) { result in

      switch result {

      case .success(let placeID):
        if !placeID.candidates.isEmpty {
          self.placeID = placeID.candidates[0].placeID
          self.performSegue(withIdentifier: "NavigateToResultVC", sender: self)
          self.searchBar.text = ""

        } else {
          self.alertForSearchError(message: placeID.status)
        }

      case .failure(let error):
        self.alertForSearchError(message: error.localizedDescription)
      }
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

// MARK:UISearchBarDelegate
extension ViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    guard let input = searchBar.text else { return }
    requestPlaceID(input: input)
  }
}
