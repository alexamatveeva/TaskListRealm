//
//  CategoryCell.swift
//  TaskListRealm
//
//  Created by Alexandra on 08.07.2022.
//

import UIKit

class CategoryCell: UITableViewCell {

    static let identifier = "CategoryCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
