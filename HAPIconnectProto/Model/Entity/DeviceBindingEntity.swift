//
//  DeviceBindingEntity.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DeviceBindingEntity: NSManagedObject
{
    @NSManaged var isDeviceDeleted      : Bool
    @NSManaged var accountID            : String
    @NSManaged var broadcast            : String
    @NSManaged var deviceBindingID      : String
    @NSManaged var deviceID             : String
    @NSManaged var deviceSn             : String
    @NSManaged var mac                  : String
    @NSManaged var memberID             : String
    @NSManaged var password             : String
    @NSManaged var serviceNo            : String
    @NSManaged var deviceUserNo         : Int64
    @NSManaged var maxUserQuantity      : Int64
}
