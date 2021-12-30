//
//  CollectionViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/29.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let viewModel = CollectionViewModel()
    var savedPlaces: [PlaceDetail] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        fetchSavedPlaces()
        bindSavedPlaces ()
    }
    
    func layoutView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bindSavedPlaces() {
        viewModel.savedPlacesDetail.bind { [weak self] place in
            if let place = place {
                self?.savedPlaces.append(place)
            }
        }
        
        viewModel.onSavedPlaceDetailError = { error in
            print(error)
        }
    }
    
    func fetchSavedPlaces() {
        // 先抓回 place id 再去 call google api
        viewModel.fetchSavedPlaces()
        
        #warning("連續call api decoupling")
        // 抓回firebase存的id
        viewModel.onFetchSavedPlaces = { result in
            print("從Firebase 拿到\(result)")
            // 把 id 暫存在viewcontroller裏後再拿出來去call google api
            for placeid in result {
                self.viewModel.fetchPlaceDetail(placeID: placeid)
            }
        }

    }
}

extension CollectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        let placeDetail = savedPlaces[indexPath.row]
        cell.config(placeDetail: placeDetail)
        return cell
    }
}

extension CollectionViewController: UITableViewDelegate {
    
}
