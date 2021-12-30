//
//  PlaceDetailViewController.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/29.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func savePlaceID(_ sender: UIButton) {
        placeDetailViewModel?.savePlace()
    }
    
    
    @IBAction func goCollectionPage(_ sender: UIButton) {
        guard let collectionVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else { return }
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    // MARK: - Properties
    
    var placeDetailViewModel: PlaceDetailViewModel?
    var placeDetail: PlaceDetail? {
        didSet {
            #warning("UI延遲效果")
            updateView(with: placeDetail)
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindPlaceDetail()
        fetchPlaceDetail()
    }
    
    // MARK: - Functions
    
    static func initialize(placeDetailViewModel: PlaceDetailViewModel) -> PlaceDetailViewController {
        let placeDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PlaceDetailViewController") as? PlaceDetailViewController
        placeDetailVC?.placeDetailViewModel = placeDetailViewModel
        return placeDetailVC!
    }
    
    func updateView(with placeDetail: PlaceDetail?) {
        if let name = placeDetail?.result?.name, let add = placeDetail?.result?.vicinity {
            nameLabel.text = name
            timeLabel.text = add
        }
    }
    
    func bindPlaceDetail() {
        placeDetailViewModel?.placeDetail.bind(listener: { [weak self] placeDetail in
            self?.placeDetail = placeDetail
        })
    }
    
    func fetchPlaceDetail() {
        placeDetailViewModel?.fetchPlaceDetail()
    }
}
