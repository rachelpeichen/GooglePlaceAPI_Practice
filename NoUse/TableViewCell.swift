//
//  TableViewCell.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/31.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet weak var placeImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func layoutTableCell(name: String, address: String) {
    nameLabel.text = name
    addressLabel.text = address
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
