//
//  WeightSummaryTableViewCell.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/16/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class WeightSummaryTableViewCell: UITableViewCell
{
    // MARK: - IBOutlet
    
    @IBOutlet var dateLabel     : UILabel!
    
    // MARK: - View Management
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
