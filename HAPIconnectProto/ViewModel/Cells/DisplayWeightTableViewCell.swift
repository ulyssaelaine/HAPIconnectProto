//
//  DisplayWeightTableViewCell.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/16/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class DisplayWeightTableViewCell: UITableViewCell
{
    // MARK: - IBOutlet
    
    @IBOutlet var timeImageView             : UIImageView!
    @IBOutlet var timeLabel                 : UILabel!
    @IBOutlet var weightValueLabel          : UILabel!
    @IBOutlet var bodyFatPercentageLabel    : UILabel!
    @IBOutlet var waterWeightLabel          : UILabel!
    @IBOutlet var boneMassLabel             : UILabel!
    @IBOutlet var bodyMassIndexLabel        : UILabel!
    @IBOutlet var leanMassLabel             : UILabel!
    
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
    
    // MARK: -
    
    func setWeightRecordAccessoryType(_ weightRecordObj : WeightRecordObject)
    {
        if weightRecordObj.weight_state != WeightRecordObject.WEIGHTSTATE.WEIGHT_SYNC
        {
            let checkMark : UIImageView = UIImageView(image: UIImage(named: "x_btn"))
            self.accessoryView          = checkMark
        }
        else
        {
            self.accessoryView          = nil
            self.accessoryType          = UITableViewCellAccessoryType.checkmark
            self.tintColor              = UIColor.orange
        }
    }
}
