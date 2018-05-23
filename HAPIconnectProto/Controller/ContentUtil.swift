//
//  ContentUtil.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class ContentUtil: NSObject
{
    // MARK: - Shared Instance
    
    static let sharedInstance : ContentUtil =
    {
        let instance = ContentUtil()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Arrays
    
    func devicesArray() -> [NSString]
    {
        return ["Weight",
                "Pedometer",
                "Blood Pressure"]
    }
    
    func scanDeviceTypes() -> NSArray
    {
        return [LS_WEIGHT_SCALE.rawValue,
                LS_SPHYGMOMETER.rawValue,
                LS_PEDOMETER.rawValue,
                LS_FAT_SCALE.rawValue]
    }
    
    // MARK: - UIImage
    
    func getDeviceImageByDeviceType(deviceType : LSDeviceType) -> UIImage
    {
        var image : UIImage?
        
        if (deviceType == LS_FAT_SCALE)
        {
            image = UIImage(named:"fat_scale.png")
        }
        else if (deviceType == LS_SPHYGMOMETER)
        {
            image = UIImage(named:"blood_pressure.png")
        }
        else if (deviceType == LS_PEDOMETER)
        {
            image = UIImage(named:"pedometer.png")
        }
        else if (deviceType == LS_KITCHEN_SCALE)
        {
            image = UIImage(named:"kitchen_scale.png")
        }
        else if (deviceType == LS_HEIGHT_MIRIAM)
        {
            image = UIImage(named:"height.png")
        }
        else
        {
            image = UIImage(named:"weight_scale.png")
        }
        
        return image!
    }
}
