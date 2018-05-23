//
//  DeviceListTableViewCell.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/16/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class DeviceListTableViewCell: UITableViewCell
{
    // MARK: - IBOutlet
    
    @IBOutlet var noDeviceLabel     : UILabel!
    
    @IBOutlet var deviceImageView   : UIImageView!
    @IBOutlet var deviceNameLabel   : UILabel!
    @IBOutlet var lastSyncLabel     : UILabel!
    @IBOutlet var deviceStatusLabel : UILabel!
    
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
    
    func deviceConnected(_ isConnected : Bool)
    {
        if isConnected
        {
            deviceStatusLabel.text      = "Connecté"
            deviceStatusLabel.textColor = UIColor.green
        }
        else
        {
            deviceStatusLabel.text      = "Pas connecté"
            deviceStatusLabel.textColor = UIColor.red
        }
    }
}
