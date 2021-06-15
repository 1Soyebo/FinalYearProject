//
//  FYMenuTableViewCell.swift
//  FinalYearProject
//
//  Created by Ibukunoluwa Soyebo on 11/06/2021.
//

import UIKit

class FYMenuTableViewCell: UITableViewCell {
    
    static let identifier = "FYMenuTableViewCell"
    
    static func getNib() -> UINib{
        return .init(nibName: identifier, bundle: nil)
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
