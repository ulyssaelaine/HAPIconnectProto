//
//  DeviceListViewController.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/15/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class DeviceListViewController: UITableViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet var deviceListTableView   : UITableView!
    
    // MARK: - Variables
    
    var deviceListCell                  : DeviceListTableViewCell?
    var noDeviceListCell                : DeviceListTableViewCell?
    
    var deviceListCellIdentifier        : String                            = "DeviceListTableViewCell"
    var noDeviceListCellIdentifier      : String                            = "NoDeviceTableViewCell"
    
    var manager : WebServiceManager     = WebServiceManager()
    
    var bleManager                      = LSBLEDeviceManager()
    var deviceType                      = NSArray()
    var pairedDeviceArray               = NSMutableArray()
    var protocolType                    : String?
    
    var unbindDeviceAlert               = UIAlertController()
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Initialize BLE */
        
        bleManager          = LSBLEDeviceManager.defaultLsBle()
        
        /* Check Bluetooth Status */
        
        bleManager.checkBluetoothStatus( { (isSupportFlags : Bool, isOpenFlags : Bool) in
                
            if (!isSupportFlags || !isOpenFlags)
            {
                DispatchQueue.main.async
                {
                    self.showAlert(title: "Statut Bluetooth", message: "Bluetooth a été arrêté.")
                }
            }
            
        })
        
        /* Remove TableView Footer */
        
        deviceListTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = "Liste des périphériques"
        
        /* Content */
        
        self.loadDeviceList()
        
        /* Start Data Receive */
        
        self.startDataReceive()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        bleManager.stopDataReceiveService()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load Device List
    
    func loadDeviceList()
    {
        pairedDeviceArray.removeAllObjects()
        
        /* Load Paired Devices */
        
        for deviceTypeArray in deviceType
        {
            let deviceTypeTemp : Int = deviceTypeArray as! Int
            
            let deviceArray = StorageManager.sharedInstance.getDeviceByDeviceType(deviceType: deviceTypeTemp)
            
            if deviceArray.count != 0
            {
                for devices in deviceArray
                {
                    let deviceObj : DeviceObject = devices as! DeviceObject
                    pairedDeviceArray.add(deviceObj)
                    
                    let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: deviceObj.deviceID)
                    let lsDeviceInfo : LSDeviceInfo = AppUtil.sharedInstance.convertToDeviceInfo(deviceObj, deviceBindingObj: deviceBindingObj)
                    bleManager.addMeasureDevice(lsDeviceInfo)
                    
                    let deviceType : LSDeviceType = AppUtil.sharedInstance.stringToDeviceType(deviceObj.deviceType)
                    
                    if deviceType == LS_PEDOMETER
                    {
                        self.setupPedometerUserInfoOnSyncMode(deviceObj.deviceID)
                    }
                }
            }
        }
        
        DispatchQueue.main.async
        {
            self.deviceListTableView.reloadData()
        }
    }
    
    // MARK: - Get Current User
    
    func currentDeviceUser() -> AccountObject
    {
        let accountID   = UserDefaults.standard.value(forKey: "accountID") as? String
        let accountObj : AccountObject = StorageManager.sharedInstance.getAccountInfo(accountID: accountID!)
        
        return accountObj
    }
    
    // MARK: - Setup Pedometer
    
    func setupPedometerUserInfoOnSyncMode(_ deviceID : String)
    {
        if !deviceID.isEmpty
        {
            let pedometerUserInfo : LSPedometerUserInfo = AppUtil.sharedInstance.getPedometerUserInfo(self.currentDeviceUser())
            pedometerUserInfo.deviceId = deviceID
            
            bleManager.setPedometerUserInfo(pedometerUserInfo)
        }
    }
    
    // MARK: - Show UIAlert
    
    func showAlert(title : String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction        = UIAlertAction(title: "OK", style: .cancel, handler:nil)
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async
            {
                self.present(alertController, animated: true, completion:{})
        }
    }
    
    func showUnbindDeviceAlert(_ tag : Int)
    {
        unbindDeviceAlert = UIAlertController(title: "Voulez-vous vraiment supprimer cette entrée ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction        = UIAlertAction(title: "Non", style: .cancel, handler:nil)
        
        unbindDeviceAlert.addAction(cancelAction)
        
        let okAction        = UIAlertAction(title: "Oui", style: .destructive, handler: { action in
            
            let deviceObj : DeviceObject = self.pairedDeviceArray[tag] as! DeviceObject
            let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: deviceObj.deviceID)
            
            self.unbindDevice(deviceObj.deviceID, userNum: deviceBindingObj.deviceUserNo, memberID: deviceBindingObj.memberID)
        })
        
        unbindDeviceAlert.addAction(okAction)
        
        DispatchQueue.main.async
            {
                self.present(self.unbindDeviceAlert, animated: true, completion:{})
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func addDeviceButtonTapped(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: "addDeviceSegue", sender: deviceType)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addDeviceSegue"
        {
            let deviceType = sender as! NSArray
            
            let searchDeviceVC          = segue.destination as! SearchDeviceViewController
            searchDeviceVC.deviceType   = deviceType
        }
        else if segue.identifier == "showWeightSummarySegue"
        {
            let deviceObj : DeviceObject = sender as! DeviceObject
            
            let weightSummaryVC         = segue.destination as! WeightSummaryViewController
            weightSummaryVC.deviceObj   = deviceObj
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if pairedDeviceArray.count != 0
        {
            return pairedDeviceArray.count
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if pairedDeviceArray.count != 0
        {
            deviceListCell = (tableView.dequeueReusableCell(withIdentifier: deviceListCellIdentifier) as? DeviceListTableViewCell)!
            
            let deviceObj : DeviceObject            = pairedDeviceArray[indexPath.row] as! DeviceObject
            let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: deviceObj.deviceID)
            
            deviceListCell?.deviceNameLabel.text    = "\(deviceObj.deviceName):\(deviceBindingObj.broadcast)"
            
            deviceListCell?.deviceImageView.image   = ContentUtil.sharedInstance.getDeviceImageByDeviceType(deviceType: LSDeviceType(rawValue: LSDeviceType.RawValue(deviceObj.deviceType)))
            
            /* ----- WEIGHT ----- */
            
            if deviceType.contains(LS_WEIGHT_SCALE.rawValue)
            {
                let lastestWeightRecord : WeightRecordObject = StorageManager.sharedInstance.getLatestWeightRecordByDeviceID(deviceID: deviceObj.deviceID)
                
                deviceListCell?.lastSyncLabel.text      = lastestWeightRecord.measurementDate.isEmpty ? "" : "Dernière synchronisation: \(lastestWeightRecord.measurementDate)"
            }
            
            /* ----- PEDOMETER ----- */
            
            else if deviceType.contains(LS_PEDOMETER.rawValue)
            {
                deviceListCell?.lastSyncLabel.text      = ""//"Dernière synchronisation:"
            }
            
            /* ----- BLOOD PRESSURE ----- */
            
            else if deviceType.contains(LS_SPHYGMOMETER.rawValue)
            {
                deviceListCell?.lastSyncLabel.text      = ""//"Dernière synchronisation:"
            }
        
            return deviceListCell!
        }
        else
        {
            noDeviceListCell = (tableView.dequeueReusableCell(withIdentifier: noDeviceListCellIdentifier) as? DeviceListTableViewCell)!
            
            return noDeviceListCell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if pairedDeviceArray.count != 0
        {
            return 85
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            /* ----- WEIGHT ----- */
        
        if deviceType.contains(LS_WEIGHT_SCALE.rawValue)
        {
            let deviceObj : DeviceObject        = pairedDeviceArray[indexPath.row] as! DeviceObject
            
            self.performSegue(withIdentifier: "showWeightSummarySegue", sender: deviceObj)
        }
        
            /* ----- PEDOMETER ----- */
            
        else if deviceType.contains(LS_PEDOMETER.rawValue)
        {
            
        }
            
            /* ----- BLOOD PRESSURE ----- */
            
        else if deviceType.contains(LS_SPHYGMOMETER.rawValue)
        {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if pairedDeviceArray.count != 0
        {
            return true
        }
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        if pairedDeviceArray.count != 0
        {
            return UITableViewCellEditingStyle.delete
        }
        
        return UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            /* ----- PEDOMETER ----- */
            
            if protocolType == "A2"
            {
                let deviceObj : DeviceObject = pairedDeviceArray[indexPath.row] as! DeviceObject
                StorageManager.sharedInstance.deleteObject(obj: deviceObj)
                pairedDeviceArray.removeObject(at: indexPath.row)
                
                DispatchQueue.main.async {
                    
                    self.deviceListTableView.reloadData()
                    
                }
            }
            else if protocolType == "A3"
            {
                /* ----- WEIGHING SCALE ----- */
                
                print("deviceType: \(deviceType)")
                
                if deviceType.contains(LS_FAT_SCALE.rawValue) || deviceType.contains(LS_WEIGHT_SCALE.rawValue) || deviceType.contains(LS_KITCHEN_SCALE.rawValue)
                {
                    self.showUnbindDeviceAlert(indexPath.row)
                }
                
                /* ----- BLOOD PRESSURE ----- */
                    
                else if deviceType.contains(LS_SPHYGMOMETER.rawValue)
                {
                    let deviceObj : DeviceObject = pairedDeviceArray[indexPath.row] as! DeviceObject
                    StorageManager.sharedInstance.deleteObject(obj: deviceObj)
                    pairedDeviceArray.removeObject(at: indexPath.row)
                    
                    DispatchQueue.main.async {
                        
                        self.deviceListTableView.reloadData()
                        
                    }
                }
            }
        }
    }
}

// MARK: - Extension - LSBleDataReceiveDelegate

extension DeviceListViewController : LSBleDataReceiveDelegate
{
    // MARK: -
    
    func startDataReceive()
    {
        if pairedDeviceArray.count != 0
        {
            print("Start Auto Sync Data")
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute:
            {
                //Background Thread
                
                DispatchQueue.main.async
                {
                    self.bleManager.startDataReceiveService(self)
                }
            })
        }
    }
    
    // MARK: - Connection State
    
    func bleManagerDidConnectStateChange(_ connectState: DeviceConnectState, deviceName: String!)
    {
        print("deviceConnection: \(connectState.rawValue)")
        
        deviceListCell = deviceListTableView.viewWithTag(1) as? DeviceListTableViewCell
        
        DispatchQueue.global(qos: .userInteractive).async(execute:
        {
            DispatchQueue.main.async {
                
                if connectState == CONNECTED_SUCCESS
                {
                    self.deviceListCell?.deviceConnected(true)
                }
                else
                {
                    self.deviceListCell?.deviceConnected(false)
                }
                
            }
        })
    }
    
    // MARK: - Pedometer
    
    func bleManagerDidReceivePedometerMeasuredData(_ data: LSPedometerData!)
    {
        
    }
    
    // MARK: - Weighing Scale
    
    func bleManagerDidReceiveWeightAppendMeasuredData(_ data: LSWeightAppendData!)
    {
        if (data != nil)
        {
            let weightRecordObj : WeightRecordObject = WeightRecordObject()
            
            weightRecordObj.basalMetabolism         = Int(data.basalMetabolism)
            weightRecordObj.pbfValue                = data.bodyFatRatio
            weightRecordObj.bodyWaterValue          = data.bodywaterRatio
            weightRecordObj.muscleValue             = data.muscleMassRatio
            weightRecordObj.boneValue               = data.boneDensity
            weightRecordObj.deviceID                = data.deviceId
            weightRecordObj.measurementDate         = CalendarUtil.sharedInstance.utcToDateString(data.utc)
            
            weightRecordObj.measurementDateTimeStamp = CalendarUtil.sharedInstance.getDateFromString(weightRecordObj.measurementDate)
            
            let dateArray                           = weightRecordObj.measurementDate.components(separatedBy: " ")
            weightRecordObj.weight_date             = dateArray.first!
            
            if StorageManager.sharedInstance.getWeightRecordByDate(date: weightRecordObj.measurementDate) is WeightRecordObject
            {
                let tempWeightRecordObj : WeightRecordObject = StorageManager.sharedInstance.getWeightRecordByDate(date: weightRecordObj.measurementDate) as! WeightRecordObject
                
                weightRecordObj.accountID           = tempWeightRecordObj.accountID
                weightRecordObj.memberID            = tempWeightRecordObj.memberID
                weightRecordObj.weightRecordID      = tempWeightRecordObj.weightRecordID
                weightRecordObj.weightValue         = tempWeightRecordObj.weightValue
                weightRecordObj.deviceSn            = tempWeightRecordObj.deviceSn
                weightRecordObj.resistance          = tempWeightRecordObj.resistance
                weightRecordObj.bmiValue            = tempWeightRecordObj.bmiValue
                weightRecordObj.pbfstate            = tempWeightRecordObj.pbfstate
                
                self.updateWeightRecord(weightRecordObj)
                
                weightRecordObj.wtstate             = 1
                weightRecordObj.weight_state        = WeightRecordObject.WEIGHTSTATE.WEIGHT_ADD_ONGOING
                
                StorageManager.sharedInstance.updateObject(obj: weightRecordObj)
            }
            else
            {
                let weightRecordEntity : WeightRecordEntity = StorageManager.sharedInstance.addObject(obj: weightRecordObj) as! WeightRecordEntity
                let weightRecord : WeightRecordObject = StorageManager.sharedInstance.getWeightRecordManagedObject(weightRecordManagedObject: weightRecordEntity)
                
                print("weightRecord: \(weightRecord)")
            }
        }
    }
    
    func bleManagerDidReceiveWeightMeasuredData(_ data: LSWeightData!)
    {
        if (data != nil)
        {
            let dateFinal   : Date      = CalendarUtil.sharedInstance.getLocalDateFromString(data.date)
            let gmtDate     : Date      = CalendarUtil.sharedInstance.convertGMTDateToCurrentTimeZone(sourceDate: dateFinal as NSDate) as Date
            let gmtDateString : String  = String(format:"%@",gmtDate as CVarArg)
            
            if !StorageManager.sharedInstance.weightEntryByDateAndWeightExists(gmtDateString as NSString, weightValue: Float(data.weight))
            {
                let accountID               = UserDefaults.standard.value(forKey: "accountID") as? String
                let memberObj   : MemberObject  = StorageManager.sharedInstance.getMemberInfo(accountID: accountID!)
                
                let weightRecordObj : WeightRecordObject = WeightRecordObject()
                
                weightRecordObj.accountID               = memberObj.accountID
                weightRecordObj.memberID                = memberObj.memberID
                weightRecordObj.weightRecordID          = String().UUIDString()
                weightRecordObj.weightValue             = Float(data.weight)
                weightRecordObj.deviceID                = data.deviceId
                weightRecordObj.deviceSn                = LSFormatter.translateDeviceId(toSN: data.deviceId)
                weightRecordObj.measurementDate         = data.date
                weightRecordObj.resistance              = Int(data.resistance_2)
                
                weightRecordObj.bmiValue                = AppUtil.sharedInstance.getBMIValueByHeightAndWeight(Float(memberObj.currentHeight)!, weightValue: weightRecordObj.weightValue)
                
                if data.hasAppendMeasurement == 1 && weightRecordObj.resistance != 0
                {
                    if weightRecordObj.resistance == 0
                    {
                        weightRecordObj.pbfValue        = 0.0
                        weightRecordObj.bodyWaterValue  = 0.0
                        weightRecordObj.muscleValue     = 0.0
                        weightRecordObj.boneValue       = 0.0
                    }
                    else
                    {
                        var heightValue : Float = Float(memberObj.currentHeight)!
                        heightValue     = heightValue / 100.0
                        let birthDate : Date = CalendarUtil.sharedInstance.getGMTDateFromString(memberObj.birthday)
                        let age : Int   = AppUtil.sharedInstance.getAgeBasedonDate(birthDate)
                        
                        /* PBF */
                        
                        let bodyFat : Float = LSFormatter.fat(byHeight: heightValue, weight: weightRecordObj.weightValue, imp: Int32(weightRecordObj.resistance), age: Int32(age), gender: Int32(memberObj.gender))
                        weightRecordObj.pbfValue    = bodyFat
                        
                        /* Body Water */
                        
                        let waterValue : Float = LSFormatter.water(byHeight: heightValue, weight: weightRecordObj.weightValue, imp: Int32(weightRecordObj.resistance), gender: Int32(memberObj.gender))
                        weightRecordObj.bodyWaterValue = waterValue
                        
                        /* Muscle */
                        
                        let muscleValue : Float = AppUtil.sharedInstance.muscleByWeight(weightRecordObj.weightValue, fat: bodyFat, gender: memberObj.gender)
                        weightRecordObj.muscleValue = muscleValue
                        
                        /* Bone Mass */
                        
                        let boneMass : Float = AppUtil.sharedInstance.boneByMuscle(muscleValue, gender: memberObj.gender)
                        weightRecordObj.boneValue   = boneMass
                    }
                }
                
                weightRecordObj.measurementDateTimeStamp = CalendarUtil.sharedInstance.getDateFromString(weightRecordObj.measurementDate)
                
                let dateArray                           = weightRecordObj.measurementDate.components(separatedBy: " ")
                
                weightRecordObj.weight_date             = dateArray.first!
                weightRecordObj.pbfstate                = 1
                weightRecordObj.wtstate                 = 1
                weightRecordObj.weight_state            = WeightRecordObject.WEIGHTSTATE.WEIGHT_ADD_ONGOING
                
                let weightRecordEntity : WeightRecordEntity = StorageManager.sharedInstance.addObject(obj: weightRecordObj) as! WeightRecordEntity
                let weightRecord : WeightRecordObject = StorageManager.sharedInstance.getWeightRecordManagedObject(weightRecordManagedObject: weightRecordEntity)
                
                print("weightRecord: \(weightRecord)")
            }
            
            else
            {
                let accountID               = UserDefaults.standard.value(forKey: "accountID") as? String
                let memberObj   : MemberObject  = StorageManager.sharedInstance.getMemberInfo(accountID: accountID!)
                
                let weightRecordObj : WeightRecordObject = WeightRecordObject()
                
                weightRecordObj.accountID               = memberObj.accountID
                weightRecordObj.memberID                = memberObj.memberID
                weightRecordObj.weightRecordID          = String().UUIDString()
                weightRecordObj.weightValue             = Float(data.weight)
                weightRecordObj.deviceID                = data.deviceId
                weightRecordObj.deviceSn                = LSFormatter.translateDeviceId(toSN: data.deviceId)
                weightRecordObj.measurementDate         = data.date
                
                weightRecordObj.measurementDateTimeStamp = CalendarUtil.sharedInstance.getDateFromString(weightRecordObj.measurementDate)
                
                weightRecordObj.resistance              = Int(data.resistance_2)
                
                weightRecordObj.bmiValue                = AppUtil.sharedInstance.getBMIValueByHeightAndWeight(Float(memberObj.currentHeight)!, weightValue: weightRecordObj.weightValue)
                
                let tempWeight : WeightRecordObject = StorageManager.sharedInstance.getWeightRecordByDate(date: data.date) as! WeightRecordObject
                
                weightRecordObj.pbfValue                = tempWeight.pbfValue
                weightRecordObj.bodyWaterValue          = tempWeight.bodyWaterValue
                weightRecordObj.muscleValue             = tempWeight.muscleValue
                weightRecordObj.boneValue               = tempWeight.boneValue
                weightRecordObj.pbfstate                = 1
                
                let dateArray                           = weightRecordObj.measurementDate.components(separatedBy: " ")
                
                weightRecordObj.weight_date             = dateArray.first!
                weightRecordObj.pbfstate                = 1
                weightRecordObj.wtstate                 = 1
                weightRecordObj.weight_state            = WeightRecordObject.WEIGHTSTATE.WEIGHT_ADD_ONGOING
                
                StorageManager.sharedInstance.updateObject(obj: weightRecordObj)
                
                self.updateWeightRecord(weightRecordObj)
            }
        }
        
        DispatchQueue.main.async {
            
            self.deviceListTableView.reloadData()
            
        }
    }
    
    // MARK: - Blood Pressure
    
    func bleManagerDidReceive(_ userInfo: LSProductUserInfo!) {}
    
    func bleManagerDidWriteSuccess(forAlarmClock deviceId: String!, memberId: String!) {}
    
    func bleManagerDidDiscoveredDeviceInfo(_ deviceInfo: LSDeviceInfo!) {}
    
    func bleManagerDidReceiveSphygmometerMeasuredData(_ data: LSSphygmometerData!)
    {
        
    }
}

// MARK: - Extension - WebServiceManagerDelegate

extension DeviceListViewController : WebServiceManagerDelegate
{
    func updateWeightRecord(_ weightRecordObj : WeightRecordObject)
    {
        manager.delegate = self
        manager.saveWeight(weightRecordObj)
    }
    
    func unbindDevice(_ deviceID : String, userNum : Int, memberID : String)
    {
        manager.delegate = self
        manager.unbindThirdPartyDevice(deviceID, userNum: userNum, memberID: memberID)
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, loginUserSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, loginUserFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceSuccess success: NSString, protocolType: String)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceFailed error: NSString, protocolType: String)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceSuccess success: NSString)
    {
        /* Content */
        
        self.loadDeviceList()
        
        /* Reload Data */
        
        DispatchQueue.main.async {
            
            self.deviceListTableView.reloadData()
            
        }
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceFailed error: NSString)
    {
        self.showAlert(title: "Unbind Device Failed", message: error as String)
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, savePedometerStepsSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, savePedometerStepsFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deletePedometerStepsSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deletePedometerStepsFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightSuccess success : NSString)
    {
        /* Content */
        
        self.loadDeviceList()
        
        /* Reload Data */
        
        DispatchQueue.main.async {
            
            self.deviceListTableView.reloadData()
            
        }
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveBloodPressureRecordSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveBloodPressureRecordFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteBloodPressureRecordSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteBloodPressureRecordFailed error: NSString)
    {
        
    }
}
