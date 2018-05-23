//
//  WeightRecordEntity.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class WeightRecordEntity: NSManagedObject
{
    @NSManaged var accountID            : String
    @NSManaged var basalMetabolism      : Int64
    @NSManaged var bmiValue             : Float
    @NSManaged var bodyWaterValue       : Float
    @NSManaged var boneValue            : Float
    @NSManaged var deviceID             : String
    @NSManaged var deviceSn             : String
    @NSManaged var isWeightRecordDeleted : Bool
    @NSManaged var measurementDate      : String
    @NSManaged var measurementDateTimeStamp : Date
    @NSManaged var memberID             : String
    @NSManaged var muscleValue          : Float
    @NSManaged var pbfstate             : Int64
    @NSManaged var pbfValue             : Float
    @NSManaged var remark               : String
    @NSManaged var resistance           : Int64
    @NSManaged var visceralFatLevel     : Int64
    @NSManaged var weight_date          : String
    @NSManaged var weight_state         : Int16
    @NSManaged var weightRecordID       : String
    @NSManaged var weightValue          : Float
    @NSManaged var wtstate              : Int64
}
