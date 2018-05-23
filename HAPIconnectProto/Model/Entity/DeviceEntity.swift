//
//  DeviceEntity.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DeviceEntity: NSManagedObject
{
    @NSManaged var deviceID             : String
    @NSManaged var deviceName           : String
    @NSManaged var deviceQRCode         : String
    @NSManaged var deviceSn             : String
    @NSManaged var deviceType           : Int64
    @NSManaged var mac                  : String
    @NSManaged var modelNum             : String
    @NSManaged var picture              : String
    @NSManaged var protocolType         : String
    @NSManaged var communicationType    : Int64
    @NSManaged var maxUserQuantity      : Int64
}
