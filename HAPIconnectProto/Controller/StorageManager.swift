//
//  StorageManager.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StorageManager: NSObject
{
    // MARK: Shared Instance
    
    static let sharedInstance : StorageManager =
    {
        let instance = StorageManager()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Get Core Data
    
    func getEntryWithObjectID(_ objectId : NSString) -> Any
    {
        let context: NSManagedObjectContext?    = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let persistentStore : NSPersistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        return context?.object(with: persistentStore.managedObjectID(forURIRepresentation: URL(string: objectId as String)!)!) as Any
    }
    
    // MARK: - Add Object
    
    func addObject(obj: Any) -> Any
    {
        var returnObject : Any?
        
        let context: NSManagedObjectContext?    = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        if (obj is AccountObject)
        {
            var accountManagedObject        : AccountEntity?
            
            accountManagedObject            = NSEntityDescription.insertNewObject(forEntityName: "AccountEntity", into: context!) as? AccountEntity
            
            accountManagedObject            = self.accountManagedObject(accountManagedObject: accountManagedObject!, fromAccountObj: obj as! AccountObject)
            
            returnObject                    = accountManagedObject
        }
        else if (obj is MemberObject)
        {
            var memberManagedObject         : MemberEntity?
            
            memberManagedObject             = NSEntityDescription.insertNewObject(forEntityName: "MemberEntity", into: context!) as? MemberEntity
            
            memberManagedObject             = self.memberManagedObject(memberManagedObject: memberManagedObject!, fromMemberObj: obj as! MemberObject)
            
            returnObject                    = memberManagedObject
        }
        else if (obj is DeviceObject)
        {
            var deviceManagedObject         : DeviceEntity?
            
            deviceManagedObject             = NSEntityDescription.insertNewObject(forEntityName: "DeviceEntity", into: context!) as? DeviceEntity
            
            deviceManagedObject             = self.deviceManagedObject(deviceManagedObject: deviceManagedObject!, fromDeviceObj: obj as! DeviceObject)
            
            returnObject                    = deviceManagedObject
        }
        else if (obj is DeviceBindingObject)
        {
            var deviceBindingManagedObject  : DeviceBindingEntity?
            
            deviceBindingManagedObject      = NSEntityDescription.insertNewObject(forEntityName: "DeviceBindingEntity", into: context!) as? DeviceBindingEntity
            
            deviceBindingManagedObject      = self.deviceBindingManagedObject(deviceBindingManagedObject: deviceBindingManagedObject!, fromDeviceBindingObj: obj as! DeviceBindingObject)
            
            returnObject                    = deviceBindingManagedObject
        }
        else if (obj is WeightRecordObject)
        {
            var weightRecordManagedObject   : WeightRecordEntity?
            
            weightRecordManagedObject       = NSEntityDescription.insertNewObject(forEntityName: "WeightRecordEntity", into: context!) as? WeightRecordEntity
            
            weightRecordManagedObject       = self.weightRecordManagedObject(weightRecordManagedObject: weightRecordManagedObject!, fromWeightRecordObj: obj as! WeightRecordObject)
            
            returnObject                    = weightRecordManagedObject
        }
        
        do
        {
            try context?.save()
        }
        catch
        {
            print("Can't Save! \(error) \(error.localizedDescription)")
        }
        
        return returnObject!
    }
    
    // MARK: - Update Object
    
    func updateObject(obj : Any)
    {
        let context: NSManagedObjectContext?                = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        if (obj is AccountObject)
        {
            let accountObj : AccountObject                  = obj as! AccountObject
            
            let fetchRequest : NSFetchRequest<AccountEntity>    = NSFetchRequest<AccountEntity>()
            
            let entity                  = NSEntityDescription.entity(forEntityName: "AccountEntity", in: context!)
            fetchRequest.entity         = entity
            
            let predicate : NSPredicate = NSPredicate(format: "accountID == %@", accountObj.accountID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let records             = try context?.fetch(fetchRequest)
                
                for accountManagedObject in records!
                {
                    accountManagedObject.accountID      = accountObj.accountID
                    accountManagedObject.bpUnit         = accountObj.bpUnit
                    accountManagedObject.email          = accountObj.email
                    accountManagedObject.firstName      = accountObj.firstName
                    accountManagedObject.heightUnit     = accountObj.heightUnit
                    accountManagedObject.mobileNum      = accountObj.mobileNum
                    accountManagedObject.userName       = accountObj.userName
                    accountManagedObject.heightUnit     = accountObj.heightUnit
                    accountManagedObject.weightUnit     = accountObj.weightUnit
                }
            }
            catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is MemberObject)
        {
            let memberObj : MemberObject                = obj as! MemberObject
            
            let fetchRequest : NSFetchRequest<MemberEntity>    = NSFetchRequest<MemberEntity>()
            
            let entity                  = NSEntityDescription.entity(forEntityName: "MemberEntity", in: context!)
            fetchRequest.entity         = entity
            
            let predicate : NSPredicate = NSPredicate(format: "memberID == %@", memberObj.memberID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let records             = try context?.fetch(fetchRequest)
                
                for memberManagedObject in records!
                {
                    memberManagedObject.accountID       = memberObj.accountID
                    memberManagedObject.birthday        = memberObj.birthday
                    memberManagedObject.currentHeight   = memberObj.currentHeight
                    memberManagedObject.startWeight     = memberObj.startWeight
                    memberManagedObject.enableBloodPressure = memberObj.enableBloodPressure
                    memberManagedObject.enableHeight    = memberObj.enableHeight
                    memberManagedObject.enablePedometer = memberObj.enablePedometer
                    memberManagedObject.enableWeight    = memberObj.enableWeight
                    memberManagedObject.enableWeightGoal    = memberObj.enableWeightGoal
                    memberManagedObject.firstName       = memberObj.firstName
                    memberManagedObject.gender          = Int64(memberObj.gender)
                    memberManagedObject.isMembershipDeleted = memberObj.isMembershipDeleted
                    memberManagedObject.memberID        = memberObj.memberID
                    memberManagedObject.pictureURL      = memberObj.pictureURL
                    memberManagedObject.weightGoal      = memberObj.weightGoal
                }
            }
            catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is DeviceObject)
        {
            let deviceObj : DeviceObject                = obj as! DeviceObject
            
            let fetchRequest : NSFetchRequest<DeviceEntity>    = NSFetchRequest<DeviceEntity>()
            
            let entity                  = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
            fetchRequest.entity         = entity
            
            let predicate : NSPredicate = NSPredicate(format: "deviceID == %@", deviceObj.deviceID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let records             = try context?.fetch(fetchRequest)
                
                for deviceManagedObject in records!
                {
                    deviceManagedObject.deviceID        = deviceObj.deviceID
                    deviceManagedObject.deviceID        = deviceObj.deviceID
                    deviceManagedObject.deviceName      = deviceObj.deviceName
                    deviceManagedObject.deviceQRCode    = deviceObj.deviceSn
                    deviceManagedObject.deviceSn        = deviceObj.deviceSn
                    deviceManagedObject.deviceType      = Int64(deviceObj.deviceType)
                    deviceManagedObject.mac             = deviceObj.mac
                    deviceManagedObject.modelNum        = deviceObj.modelNum
                    deviceManagedObject.picture         = deviceObj.picture
                    deviceManagedObject.protocolType    = deviceObj.protocolType
                    deviceManagedObject.communicationType    = Int64(deviceObj.communicationType)
                    deviceManagedObject.maxUserQuantity      = Int64(deviceObj.maxUserQuantity)
                }
            }
            catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is DeviceBindingObject)
        {
            let deviceBindingObj : DeviceBindingObject              = obj as! DeviceBindingObject
            
            let fetchRequest : NSFetchRequest<DeviceBindingEntity>  = NSFetchRequest<DeviceBindingEntity>()
            
            let entity                  = NSEntityDescription.entity(forEntityName: "DeviceBindingEntity", in: context!)
            fetchRequest.entity         = entity
            
            let predicate : NSPredicate = NSPredicate(format: "deviceBindingID == %@", deviceBindingObj.deviceBindingID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let records             = try context?.fetch(fetchRequest)
                
                for deviceBindingManagedObject in records!
                {
                    deviceBindingManagedObject.isDeviceDeleted  = deviceBindingObj.isDeviceDeleted
                    deviceBindingManagedObject.accountID        = deviceBindingObj.accountID
                    deviceBindingManagedObject.broadcast        = deviceBindingObj.broadcast
                    deviceBindingManagedObject.deviceBindingID  = deviceBindingObj.deviceBindingID
                    deviceBindingManagedObject.deviceID         = deviceBindingObj.deviceID
                    deviceBindingManagedObject.deviceSn         = deviceBindingObj.deviceSn
                    deviceBindingManagedObject.mac              = deviceBindingObj.mac
                    deviceBindingManagedObject.memberID         = deviceBindingObj.memberID
                    deviceBindingManagedObject.serviceNo        = deviceBindingObj.serviceNo
                    deviceBindingManagedObject.deviceUserNo     = Int64(deviceBindingObj.deviceUserNo)
                    deviceBindingManagedObject.maxUserQuantity  = Int64(deviceBindingObj.deviceUserNo)
                }
            }
            catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is WeightRecordObject)
        {
            let weightRecordObj : WeightRecordObject         = obj as! WeightRecordObject
            
            let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
            
            let entity                  = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
            fetchRequest.entity         = entity
            
            let predicate : NSPredicate = NSPredicate(format: "weightRecordID == %@", weightRecordObj.weightRecordID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let records             = try context?.fetch(fetchRequest)
                
                for weightRecordManagedObject in records!
                {
                    weightRecordManagedObject.accountID         = weightRecordObj.accountID
                    weightRecordManagedObject.basalMetabolism   = Int64(weightRecordObj.basalMetabolism)
                    weightRecordManagedObject.bmiValue          = weightRecordObj.bmiValue
                    weightRecordManagedObject.bodyWaterValue    = weightRecordObj.bodyWaterValue
                    weightRecordManagedObject.boneValue         = weightRecordObj.boneValue
                    weightRecordManagedObject.deviceID          = weightRecordObj.deviceID
                    weightRecordManagedObject.deviceSn          = weightRecordObj.deviceSn
                    weightRecordManagedObject.isWeightRecordDeleted = weightRecordObj.isWeightRecordDeleted
                    weightRecordManagedObject.measurementDate   = weightRecordObj.measurementDate
                    weightRecordManagedObject.measurementDateTimeStamp = weightRecordObj.measurementDateTimeStamp
                    weightRecordManagedObject.memberID          = weightRecordObj.memberID
                    weightRecordManagedObject.muscleValue       = weightRecordObj.muscleValue
                    weightRecordManagedObject.pbfstate          = Int64(weightRecordObj.pbfstate)
                    weightRecordManagedObject.pbfValue          = weightRecordObj.pbfValue
                    weightRecordManagedObject.remark            = weightRecordObj.remark
                    weightRecordManagedObject.resistance        = Int64(weightRecordObj.resistance)
                    weightRecordManagedObject.visceralFatLevel  = Int64(weightRecordObj.visceralFatLevel)
                    weightRecordManagedObject.weight_date       = weightRecordObj.weight_date
                    weightRecordManagedObject.weightRecordID    = weightRecordObj.weightRecordID
                    weightRecordManagedObject.weight_state      = Int16(weightRecordObj.weight_state.rawValue)
                    weightRecordManagedObject.weightValue       = weightRecordObj.weightValue
                    weightRecordManagedObject.wtstate           = Int64(weightRecordObj.wtstate)
                }
            }
            catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delete Object
    
    func deleteObject(obj : Any)
    {
        let context: NSManagedObjectContext?                            = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        if (obj is AccountObject)
        {
            let fetchRequest : NSFetchRequest<AccountEntity> = NSFetchRequest<AccountEntity>()
            
            let entity = NSEntityDescription.entity(forEntityName: "AccountEntity", in: context!)
            fetchRequest.entity = entity
            
            fetchRequest.includesPropertyValues = false
            
            let predicate : NSPredicate = NSPredicate(format: "accountID == %@", (obj as! AccountObject).accountID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let result = try context?.fetch(fetchRequest)
                
                for managedObject in result!
                {
                    context?.delete(managedObject)
                }
                
                try context?.save()
                
            } catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is MemberObject)
        {
            let fetchRequest : NSFetchRequest<MemberEntity> = NSFetchRequest<MemberEntity>()
            
            let entity = NSEntityDescription.entity(forEntityName: "MemberEntity", in: context!)
            fetchRequest.entity = entity
            
            fetchRequest.includesPropertyValues = false
            
            let predicate : NSPredicate = NSPredicate(format: "memberID == %@", (obj as! MemberObject).memberID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let result = try context?.fetch(fetchRequest)
                
                for managedObject in result!
                {
                    context?.delete(managedObject)
                }
                
                try context?.save()
                
            } catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is DeviceObject)
        {
            let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
            
            let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
            fetchRequest.entity = entity
            
            fetchRequest.includesPropertyValues = false
            
            let predicate : NSPredicate = NSPredicate(format: "deviceID == %@", (obj as! DeviceObject).deviceID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let result = try context?.fetch(fetchRequest)
                
                for managedObject in result!
                {
                    context?.delete(managedObject)
                }
                
                try context?.save()
                
            } catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is DeviceBindingObject)
        {
            let fetchRequest : NSFetchRequest<DeviceBindingEntity> = NSFetchRequest<DeviceBindingEntity>()
            
            let entity = NSEntityDescription.entity(forEntityName: "DeviceBindingEntity", in: context!)
            fetchRequest.entity = entity
            
            fetchRequest.includesPropertyValues = false
            
            let predicate : NSPredicate = NSPredicate(format: "deviceBindingID == %@", (obj as! DeviceBindingObject).deviceBindingID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let result = try context?.fetch(fetchRequest)
                
                for managedObject in result!
                {
                    context?.delete(managedObject)
                }
                
                try context?.save()
                
            } catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
        else if (obj is WeightRecordObject)
        {
            let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
            
            let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
            fetchRequest.entity = entity
            
            fetchRequest.includesPropertyValues = false
            
            let predicate : NSPredicate = NSPredicate(format: "weightRecordID == %@", (obj as! WeightRecordObject).weightRecordID)
            fetchRequest.predicate      = predicate
            
            do
            {
                let result = try context?.fetch(fetchRequest)
                
                for managedObject in result!
                {
                    context?.delete(managedObject)
                }
                
                try context?.save()
                
            } catch
            {
                print("Can't Check! \(error) \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delete All
    
    func deleteAllAccountEntity()
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        let fetchRequest : NSFetchRequest<AccountEntity> = NSFetchRequest<AccountEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "AccountEntity", in: context!)
        fetchRequest.entity = entity
        
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let result = try context?.fetch(fetchRequest)
            
            for managedObject in result!
            {
                context?.delete(managedObject)
            }
            
            try context?.save()
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
    }
    
    func deleteAllMemberEntity()
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        let fetchRequest : NSFetchRequest<MemberEntity> = NSFetchRequest<MemberEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "MemberEntity", in: context!)
        fetchRequest.entity = entity
        
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let result = try context?.fetch(fetchRequest)
            
            for managedObject in result!
            {
                context?.delete(managedObject)
            }
            
            try context?.save()
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
    }
    
    func deleteAllDeviceEntity()
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
        fetchRequest.entity = entity
        
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let result = try context?.fetch(fetchRequest)
            
            for managedObject in result!
            {
                context?.delete(managedObject)
            }
            
            try context?.save()
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
    }
    
    func deleteAllDeviceBindingEntity()
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceBindingEntity> = NSFetchRequest<DeviceBindingEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceBindingEntity", in: context!)
        fetchRequest.entity = entity
        
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let result = try context?.fetch(fetchRequest)
            
            for managedObject in result!
            {
                context?.delete(managedObject)
            }
            
            try context?.save()
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
    }
    
    func deleteAllWeightRecordEntity()
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let result = try context?.fetch(fetchRequest)
            
            for managedObject in result!
            {
                context?.delete(managedObject)
            }
            
            try context?.save()
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
    }
    
    // MARK: - Check if Exists
    
    func accountEntryExists(accountObj: AccountObject) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<AccountEntity> = NSFetchRequest<AccountEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "AccountEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "accountID == %@", accountObj.accountID)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    func memberEntryExists(memberObj: MemberObject) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<MemberEntity> = NSFetchRequest<MemberEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "MemberEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "memberID == %@", memberObj.memberID)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    func deviceEntryExists(deviceObj: DeviceObject) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceID == %@", deviceObj.deviceID)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    func deviceEntryWithSerialNumExists(deviceSn: String) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceSn == %@", deviceSn)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    func deviceBindingEntryExists(deviceBindingObj: DeviceBindingObject) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceBindingEntity> = NSFetchRequest<DeviceBindingEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceBindingEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceBindingID == %@", deviceBindingObj.deviceBindingID)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    func weightEntryExists(weightRecordObj: WeightRecordObject) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "weightRecordID == %@", weightRecordObj.weightRecordID)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    func weightEntryByDateAndWeightExists(_ date : NSString, weightValue : Float) -> Bool
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "measurementDate == %@ && weightValue == %d", date, weightValue)
        fetchRequest.predicate = predicate
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if (records?.count != 0)
            {
                return true
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return false
    }
    
    // MARK: - Get Object
    
    func getAccountInfo(accountID: String) -> AccountObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<AccountEntity> = NSFetchRequest<AccountEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "AccountEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "accountID == %@", accountID)
        fetchRequest.predicate = predicate
        
        var accountObject : AccountObject = AccountObject()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                let accountManagedObject = records?[0]
                
                if (accountManagedObject != nil)
                {
                    accountObject = self.getAccountManagedObject(accountManagedObject: accountManagedObject!)
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return accountObject
    }
    
    func getMemberInfo(accountID: String) -> MemberObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<MemberEntity> = NSFetchRequest<MemberEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "MemberEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "accountID == %@", accountID)
        fetchRequest.predicate = predicate
        
        var memberObject : MemberObject = MemberObject()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                let memberManagedObject = records?[0]
                
                if (memberManagedObject != nil)
                {
                    memberObject = self.getMemberManagedObject(memberManagedObject: memberManagedObject!)
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return memberObject
    }
    
    func getDeviceByDeviceID(deviceID : String) -> DeviceObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceID == %@", deviceID)
        fetchRequest.predicate = predicate
        
        var deviceObject : DeviceObject = DeviceObject()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                let deviceManagedObject = records?[0]
                
                if (deviceManagedObject != nil)
                {
                    deviceObject = self.getDeviceManagedObject(deviceManagedObject: deviceManagedObject!)
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return deviceObject
    }
    
    func getDeviceByDeviceType(deviceType: Int) -> NSMutableArray
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceType == %d", deviceType)
        fetchRequest.predicate = predicate
        
        let devicesArray : NSMutableArray = NSMutableArray()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                for devicesRecordManagedObject in records!
                {
                    devicesArray.add(getDeviceManagedObject(deviceManagedObject: devicesRecordManagedObject))
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return devicesArray
    }
    
    func getDeviceByProtocolType(protocolType: String) -> DeviceObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceEntity> = NSFetchRequest<DeviceEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "protocolType == %@", protocolType)
        fetchRequest.predicate = predicate
        
        var deviceObject : DeviceObject = DeviceObject()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                let deviceManagedObject = records?[0]
                
                if (deviceManagedObject != nil)
                {
                    deviceObject = self.getDeviceManagedObject(deviceManagedObject: deviceManagedObject!)
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return deviceObject
    }
    
    func getDeviceBindingByDeviceID(deviceID: String) -> DeviceBindingObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<DeviceBindingEntity> = NSFetchRequest<DeviceBindingEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "DeviceBindingEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceID MATCHES[cd] %@", deviceID)
        fetchRequest.predicate = predicate
        
        var deviceBindingObject : DeviceBindingObject = DeviceBindingObject()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                let deviceBindingManagedObject = records?[0]
                
                if (deviceBindingManagedObject != nil)
                {
                    deviceBindingObject = self.getDeviceBindingManagedObject(deviceBindingManagedObject: deviceBindingManagedObject!)
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return deviceBindingObject
    }
    
    // MARK: - Get Latest
    
    func getLatestWeightRecordByDeviceID(deviceID : String) -> WeightRecordObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceID MATCHES[cd] %@", deviceID)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "measurementDateTimeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let weightRecordArray : NSMutableArray = NSMutableArray()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                for weightRecordManagedObject in records!
                {
                    weightRecordArray.add(getWeightRecordManagedObject(weightRecordManagedObject: weightRecordManagedObject))
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return weightRecordArray.firstObject as! WeightRecordObject
    }
    
    // MARK: - Get Object By Date
    
    func getWeightRecordByDate(date : String) -> NSObject
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "measurementDate == %@", date)
        fetchRequest.predicate = predicate
        
        var weightRecordObj : WeightRecordObject = WeightRecordObject()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                let weightRecordManagedObject = records?[0]
                
                if (weightRecordManagedObject != nil)
                {
                    weightRecordObj = self.getWeightRecordManagedObject(weightRecordManagedObject: weightRecordManagedObject!)
                }
                
                return weightRecordObj
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return NSObject()
    }
    
    // MARK: - Get All Objects
    
    func getWeightRecordArrayByDeviceID(deviceID : String) -> [WeightRecordObject]
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceID MATCHES[cd] %@", deviceID)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "measurementDateTimeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let weightRecordArray : NSMutableArray = NSMutableArray()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                for weightRecordManagedObject in records!
                {
                    weightRecordArray.add(getWeightRecordManagedObject(weightRecordManagedObject: weightRecordManagedObject))
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return weightRecordArray as! [WeightRecordObject]
    }
    
    func getWeightRecordArrayByDeviceIDAndDate(deviceID : String, weightDate : String) -> [WeightRecordObject]
    {
        let context: NSManagedObjectContext? = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest : NSFetchRequest<WeightRecordEntity> = NSFetchRequest<WeightRecordEntity>()
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightRecordEntity", in: context!)
        fetchRequest.entity = entity
        
        let predicate : NSPredicate = NSPredicate(format: "deviceID MATCHES[cd] %@ && weight_date == %@", deviceID, weightDate)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "measurementDateTimeStamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let weightRecordArray : NSMutableArray = NSMutableArray()
        
        do
        {
            let records = try context?.fetch(fetchRequest)
            
            if records?.count != 0
            {
                for weightRecordManagedObject in records!
                {
                    weightRecordArray.add(getWeightRecordManagedObject(weightRecordManagedObject: weightRecordManagedObject))
                }
            }
            
        } catch
        {
            print("Can't Check! \(error) \(error.localizedDescription)")
        }
        
        return weightRecordArray as! [WeightRecordObject]
    }
    
    // MARK: - Account Managed Object
    
    func accountManagedObject(accountManagedObject: AccountEntity, fromAccountObj accountObj: AccountObject) -> AccountEntity
    {
        accountManagedObject.accountID      = accountObj.accountID
        accountManagedObject.bpUnit         = accountObj.bpUnit
        accountManagedObject.email          = accountObj.email
        accountManagedObject.firstName      = accountObj.firstName
        accountManagedObject.heightUnit     = accountObj.heightUnit
        accountManagedObject.mobileNum      = accountObj.mobileNum
        accountManagedObject.userName       = accountObj.userName
        accountManagedObject.heightUnit     = accountObj.heightUnit
        accountManagedObject.weightUnit     = accountObj.weightUnit
        
        return accountManagedObject
    }
    
    func getAccountManagedObject(accountManagedObject: AccountEntity) -> AccountObject
    {
        let accountObj : AccountObject      = AccountObject()
        
        accountObj.accountID                = accountManagedObject.accountID
        accountObj.bpUnit                   = accountManagedObject.bpUnit
        accountObj.email                    = accountManagedObject.email
        accountObj.firstName                = accountManagedObject.firstName
        accountObj.heightUnit               = accountManagedObject.heightUnit
        accountObj.mobileNum                = accountManagedObject.mobileNum
        accountObj.userName                 = accountManagedObject.userName
        accountObj.heightUnit               = accountManagedObject.heightUnit
        accountObj.weightUnit               = accountManagedObject.weightUnit
        
        return accountObj
    }
    
    // MARK: - Member Managed Object
    
    func memberManagedObject(memberManagedObject: MemberEntity, fromMemberObj memberObj: MemberObject) -> MemberEntity
    {
        memberManagedObject.accountID       = memberObj.accountID
        memberManagedObject.birthday        = memberObj.birthday
        memberManagedObject.currentHeight   = memberObj.currentHeight
        memberManagedObject.startWeight     = memberObj.startWeight
        memberManagedObject.enableBloodPressure = memberObj.enableBloodPressure
        memberManagedObject.enableHeight    = memberObj.enableHeight
        memberManagedObject.enablePedometer = memberObj.enablePedometer
        memberManagedObject.enableWeight    = memberObj.enableWeight
        memberManagedObject.enableWeightGoal    = memberObj.enableWeightGoal
        memberManagedObject.firstName       = memberObj.firstName
        memberManagedObject.gender          = Int64(memberObj.gender)
        memberManagedObject.isMembershipDeleted = memberObj.isMembershipDeleted
        memberManagedObject.memberID        = memberObj.memberID
        memberManagedObject.pictureURL      = memberObj.pictureURL
        memberManagedObject.weightGoal      = memberObj.weightGoal
        
        return memberManagedObject
    }
    
    func getMemberManagedObject(memberManagedObject: MemberEntity) -> MemberObject
    {
        let memberObj : MemberObject        = MemberObject()
        
        memberObj.accountID                 = memberManagedObject.accountID
        memberObj.birthday                  = memberManagedObject.birthday
        memberObj.currentHeight             = memberManagedObject.currentHeight
        memberObj.startWeight               = memberManagedObject.startWeight
        memberObj.enableBloodPressure       = memberManagedObject.enableBloodPressure
        memberObj.enableHeight              = memberManagedObject.enableHeight
        memberObj.enablePedometer           = memberManagedObject.enablePedometer
        memberObj.enableWeight              = memberManagedObject.enableWeight
        memberObj.enableWeightGoal          = memberManagedObject.enableWeightGoal
        memberObj.firstName                 = memberManagedObject.firstName
        memberObj.gender                    = Int(memberManagedObject.gender)
        memberObj.isMembershipDeleted       = memberManagedObject.isMembershipDeleted
        memberObj.memberID                  = memberManagedObject.memberID
        memberObj.pictureURL                = memberManagedObject.pictureURL
        memberObj.weightGoal                = memberManagedObject.weightGoal
        
        return memberObj
    }
    
    // MARK: - Device Managed Object
    
    func deviceManagedObject(deviceManagedObject: DeviceEntity, fromDeviceObj deviceObj: DeviceObject) -> DeviceEntity
    {
        deviceManagedObject.deviceID        = deviceObj.deviceID
        deviceManagedObject.deviceID        = deviceObj.deviceID
        deviceManagedObject.deviceName      = deviceObj.deviceName
        deviceManagedObject.deviceQRCode    = deviceObj.deviceSn
        deviceManagedObject.deviceSn        = deviceObj.deviceSn
        deviceManagedObject.deviceType      = Int64(deviceObj.deviceType)
        deviceManagedObject.mac             = deviceObj.mac
        deviceManagedObject.modelNum        = deviceObj.modelNum
        deviceManagedObject.picture         = deviceObj.picture
        deviceManagedObject.protocolType    = deviceObj.protocolType
        deviceManagedObject.communicationType    = Int64(deviceObj.communicationType)
        deviceManagedObject.maxUserQuantity      = Int64(deviceObj.maxUserQuantity)
        
        return deviceManagedObject
    }
    
    func getDeviceManagedObject(deviceManagedObject: DeviceEntity) -> DeviceObject
    {
        let deviceObj : DeviceObject        = DeviceObject()
        
        deviceObj.deviceID                  = deviceManagedObject.deviceID
        deviceObj.deviceName                = deviceManagedObject.deviceName
        deviceObj.deviceQRCode              = deviceManagedObject.deviceQRCode
        deviceObj.deviceSn                  = deviceManagedObject.deviceSn
        deviceObj.deviceType                = Int(deviceManagedObject.deviceType)
        deviceObj.mac                       = deviceManagedObject.mac
        deviceObj.modelNum                  = deviceManagedObject.modelNum
        deviceObj.picture                   = deviceManagedObject.picture
        deviceObj.protocolType              = deviceManagedObject.protocolType
        deviceObj.communicationType         = Int(deviceManagedObject.communicationType)
        deviceObj.maxUserQuantity           = Int(deviceManagedObject.maxUserQuantity)
        
        return deviceObj
    }
    
    // MARK: - Device Binding Managed Object
    
    func deviceBindingManagedObject(deviceBindingManagedObject: DeviceBindingEntity, fromDeviceBindingObj deviceBindingObj: DeviceBindingObject) -> DeviceBindingEntity
    {
        deviceBindingManagedObject.isDeviceDeleted  = deviceBindingObj.isDeviceDeleted
        deviceBindingManagedObject.accountID        = deviceBindingObj.accountID
        deviceBindingManagedObject.broadcast        = deviceBindingObj.broadcast
        deviceBindingManagedObject.deviceBindingID  = deviceBindingObj.deviceBindingID
        deviceBindingManagedObject.deviceID         = deviceBindingObj.deviceID
        deviceBindingManagedObject.deviceSn         = deviceBindingObj.deviceSn
        deviceBindingManagedObject.mac              = deviceBindingObj.mac
        deviceBindingManagedObject.memberID         = deviceBindingObj.memberID
        deviceBindingManagedObject.password         = deviceBindingObj.password
        deviceBindingManagedObject.serviceNo        = deviceBindingObj.serviceNo
        deviceBindingManagedObject.deviceUserNo     = Int64(deviceBindingObj.deviceUserNo)
        deviceBindingManagedObject.maxUserQuantity  = Int64(deviceBindingObj.deviceUserNo)
        
        return deviceBindingManagedObject
    }
    
    func getDeviceBindingManagedObject(deviceBindingManagedObject: DeviceBindingEntity) -> DeviceBindingObject
    {
        let deviceBindingObject                = DeviceBindingObject()
        
        deviceBindingObject.isDeviceDeleted    = deviceBindingManagedObject.isDeviceDeleted
        deviceBindingObject.accountID          = deviceBindingManagedObject.accountID
        deviceBindingObject.broadcast          = deviceBindingManagedObject.broadcast
        deviceBindingObject.deviceBindingID    = deviceBindingManagedObject.deviceBindingID
        deviceBindingObject.deviceID           = deviceBindingManagedObject.deviceID
        deviceBindingObject.deviceSn           = deviceBindingManagedObject.deviceSn
        deviceBindingObject.mac                = deviceBindingManagedObject.mac
        deviceBindingObject.memberID           = deviceBindingManagedObject.memberID
        deviceBindingObject.password           = deviceBindingManagedObject.password
        deviceBindingObject.serviceNo          = deviceBindingManagedObject.serviceNo
        deviceBindingObject.deviceUserNo       = Int(deviceBindingManagedObject.deviceUserNo)
        deviceBindingObject.maxUserQuantity    = Int(deviceBindingManagedObject.deviceUserNo)
        
        return deviceBindingObject
    }
    
    // MARK: - Weight Record Managed Object
    
    func weightRecordManagedObject(weightRecordManagedObject: WeightRecordEntity, fromWeightRecordObj weightRecordObj: WeightRecordObject) -> WeightRecordEntity
    {
        weightRecordManagedObject.accountID         = weightRecordObj.accountID
        weightRecordManagedObject.basalMetabolism   = Int64(weightRecordObj.basalMetabolism)
        weightRecordManagedObject.bmiValue          = weightRecordObj.bmiValue
        weightRecordManagedObject.bodyWaterValue    = weightRecordObj.bodyWaterValue
        weightRecordManagedObject.boneValue         = weightRecordObj.boneValue
        weightRecordManagedObject.deviceID          = weightRecordObj.deviceID
        weightRecordManagedObject.deviceSn          = weightRecordObj.deviceSn
        weightRecordManagedObject.isWeightRecordDeleted = weightRecordObj.isWeightRecordDeleted
        weightRecordManagedObject.measurementDate   = weightRecordObj.measurementDate
        weightRecordManagedObject.measurementDateTimeStamp = weightRecordObj.measurementDateTimeStamp
        weightRecordManagedObject.memberID          = weightRecordObj.memberID
        weightRecordManagedObject.muscleValue       = weightRecordObj.muscleValue
        weightRecordManagedObject.pbfstate          = Int64(weightRecordObj.pbfstate)
        weightRecordManagedObject.pbfValue          = weightRecordObj.pbfValue
        weightRecordManagedObject.remark            = weightRecordObj.remark
        weightRecordManagedObject.resistance        = Int64(weightRecordObj.resistance)
        weightRecordManagedObject.visceralFatLevel  = Int64(weightRecordObj.visceralFatLevel)
        weightRecordManagedObject.weight_date       = weightRecordObj.weight_date
        weightRecordManagedObject.weightRecordID    = weightRecordObj.weightRecordID
        weightRecordManagedObject.weight_state      = Int16(weightRecordObj.weight_state.rawValue)
        weightRecordManagedObject.weightValue       = weightRecordObj.weightValue
        weightRecordManagedObject.wtstate           = Int64(weightRecordObj.wtstate)
        
        return weightRecordManagedObject
    }
    
    func getWeightRecordManagedObject(weightRecordManagedObject: WeightRecordEntity) -> WeightRecordObject
    {
        let weightRecordObject              = WeightRecordObject()
        
        weightRecordObject.accountID        = weightRecordManagedObject.accountID
        weightRecordObject.basalMetabolism  = Int(weightRecordManagedObject.basalMetabolism)
        weightRecordObject.bmiValue         = weightRecordManagedObject.bmiValue
        weightRecordObject.bodyWaterValue   = weightRecordManagedObject.bodyWaterValue
        weightRecordObject.boneValue        = weightRecordManagedObject.boneValue
        weightRecordObject.deviceID         = weightRecordManagedObject.deviceID
        weightRecordObject.deviceSn         = weightRecordManagedObject.deviceSn
        weightRecordObject.isWeightRecordDeleted = weightRecordManagedObject.isWeightRecordDeleted
        weightRecordObject.measurementDate  = weightRecordManagedObject.measurementDate
        weightRecordObject.measurementDateTimeStamp = weightRecordManagedObject.measurementDateTimeStamp
        weightRecordObject.memberID         = weightRecordManagedObject.memberID
        weightRecordObject.muscleValue      = weightRecordManagedObject.muscleValue
        weightRecordObject.pbfstate         = Int(weightRecordManagedObject.pbfstate)
        weightRecordObject.pbfValue         = weightRecordManagedObject.pbfValue
        weightRecordObject.remark           = weightRecordManagedObject.remark
        weightRecordObject.resistance       = Int(weightRecordManagedObject.resistance)
        weightRecordObject.visceralFatLevel = Int(weightRecordManagedObject.visceralFatLevel)
        weightRecordObject.weight_date      = weightRecordManagedObject.weight_date
        weightRecordObject.weight_state     = WeightRecordObject.WEIGHTSTATE(rawValue: Int(weightRecordManagedObject.weight_state))!
        weightRecordObject.weightRecordID   = weightRecordManagedObject.weightRecordID
        weightRecordObject.weightValue      = weightRecordManagedObject.weightValue
        weightRecordObject.wtstate          = Int(weightRecordManagedObject.wtstate)
        
        return weightRecordObject
    }
}
