//
//  CollectionTableViewCell.swift
//  GooglePlaceAPIPractice
//
//  Created by Rachel Chen on 2021/12/29.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(placeDetail: PlaceDetail) {
        nameLabel.text = placeDetail.result?.name
    }
}
