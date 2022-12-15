//
//  MainCellTableViewCell.swift
//  bobaholic
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainShopName: UILabel!
    
    @IBOutlet weak var shopName2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
