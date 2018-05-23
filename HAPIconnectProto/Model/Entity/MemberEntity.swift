//
//  MemberEntity.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MemberEntity: NSManagedObject
{
    @NSManaged var accountID            : String
    @NSManaged var enableWeightGoal     : Bool
    @NSManaged var birthday             : String
    @NSManaged var currentHeight        : String
    @NSManaged var enableBloodPressure  : Bool
    @NSManaged var enableHeight         : Bool
    @NSManaged var enablePedometer      : Bool
    @NSManaged var enableWeight         : Bool
    @NSManaged var firstName            : String
    @NSManaged var gender               : Int64
    @NSManaged var isMembershipDeleted  : Bool
    @NSManaged var memberID             : String
    @NSManaged var pictureURL           : String
    @NSManaged var startWeight          : String
    @NSManaged var weightGoal           : String
}
