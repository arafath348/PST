//
//  CustomTableViewCell.swift
//  PST
//
//  Created by Arafath on 28/05/17.
//
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var transButton: UIButton!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var currencyimageView: UIImageView!
    @IBOutlet var roundRectView: UIView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
