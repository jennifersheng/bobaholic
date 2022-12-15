//
//  OrderTableViewCell.swift
//  bobaholic
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
