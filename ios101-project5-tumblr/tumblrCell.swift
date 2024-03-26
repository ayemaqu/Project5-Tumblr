//
//  tumblrCell.swift
//  ios101-project5-tumblr
//
//  Created by Ayema Qureshi on 3/25/24.
//

import UIKit

class tumblrCell: UITableViewCell {

    
    @IBOutlet weak var tumblrImageView: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tumblrImageView.image = nil
        overviewLabel.text = nil
    }
}
