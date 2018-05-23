//
//  AccountEntity.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class AccountEntity: NSManagedObject
{
    @NSManaged var accountID    : String
    @NSManaged var bpUnit       : String
    @NSManaged var email        : String
    @NSManaged var firstName    : String
    @NSManaged var heightUnit   : String
    @NSManaged var mobileNum    : String
    @NSManaged var userName     : String
    @NSManaged var weightUnit   : String
}
