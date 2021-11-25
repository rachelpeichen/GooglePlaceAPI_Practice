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
      requestPlaceTextSearch(input: input)
    }
  }

  // MARK: Properties
  var searchController = UISearchController()
  var resultViewController = ResultViewController()
  var searchResult: PlaceTextSearch?

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    searchBar.delegate = self
  }

  // MARK: Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let resultVC = segue.destination as? ResultViewController {
      guard let searchResult = searchResult else { return }
      resultVC.searchResult = searchResult
      print(searchResult)
    }
  }

  func requestPlaceTextSearch(input: String) {

    APIManager.shared.requestPlaceTextSearch(input: input) { result in

      switch result {

      case .success(let searchResult):
        if !searchResult.results.isEmpty {
          self.searchResult = searchResult
          self.performSegue(withIdentifier: "NavigateToResultVC", sender: self)
          self.searchBar.text = ""

        } else {
          self.alertForSearchError(message: searchResult.status)
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

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    guard let input = searchBar.text else { return }
    requestPlaceTextSearch(input: input)
  }
}
