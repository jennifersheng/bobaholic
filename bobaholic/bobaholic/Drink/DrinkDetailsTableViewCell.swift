//
//  DrinkDetailsTableViewCell.swift
//  bobaholic
//

import UIKit

class DrinkDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var toppingsDetail: UILabel!
    @IBOutlet weak var sugarDetail: UILabel!
    @IBOutlet weak var iceDetail: UILabel!
    @IBOutlet weak var noteDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
