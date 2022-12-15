//
//  DrinkTableViewCell.swift
//  bobaholic
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
