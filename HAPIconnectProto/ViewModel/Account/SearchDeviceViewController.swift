//
//  SearchDeviceViewController.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/15/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class SearchDeviceViewController: UITableViewController, UIActionSheetDelegate
{
    // MARK: - IBOutlet
    
    @IBOutlet var searchDeviceTableView : UITableView!
    
    // MARK: - Variables
    
    var bleManager                      = LSBLEDeviceManager()
    var currentWorkingStatus            : ManagerWorkStatus?
    
    var scanResultsCell                 = ScanResultsTableViewCell()
    
    var manager : WebServiceManager     = WebServiceManager()
    
    var showUserList                    = UIActionSheet()
    var pairingSuccessful               = UIAlertController()
    var pairingFailedAlert              = UIAlertController()
    
    var scanResultsArray                = NSMutableArray()
    var deviceType                      = NSArray()
    var userNumber  : Int               = 0
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Initialize BLE */
        
        bleManager          = LSBLEDeviceManager.defaultLsBle()
        
        /* Search Device */
        
        self.searchDevice()
        
        /* Default User No */
        
        userNumber          = 0

        /* Remove TableView Footer */
        
        searchDeviceTableView.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        /* Cancel Search and Pairing Process */
        
        if currentWorkingStatus == MANAGER_WORK_STATUS_PAIR
        {
            bleManager.cancelPairingProcess()
        }
        
        bleManager.stopSearch()
    }
    
    // MARK: - Search Device
    
    func searchDevice()
    {
        self.updateLoadingLabel()
        
        bleManager.stopDataReceiveService()
        
        bleManager.searchLsBleDevice(deviceType as! [Any], of: BROADCAST_TYPE_PAIR, searchCompletion: { (_ lsDevice: LSDeviceInfo?) in
         
            print("lsDevice: \(String(describing: lsDevice))")
            
            DispatchQueue.main.async
            {
                self.scanResultsArray.add(lsDevice!)
                
                self.searchDeviceTableView.reloadData()
            }
            
        })
    }
    
    @objc func updateLoadingLabel()
    {
        if self.navigationItem.title == "Recherche d'un appareil..."
        {
            self.navigationItem.title = "Recherche d'un appareil"
        }
        else
        {
            self.navigationItem.title = String(format:"%@.",self.navigationItem.title!)
        }
        
        self.perform(#selector(self.updateLoadingLabel), with: nil, afterDelay: 1.0)
    }
    
    // MARK: - Button Actions
    
    @IBAction func searchDeviceButtonTapped(_ sender: UIBarButtonItem)
    {
        /* Refresh Searched Objects */
        
        scanResultsArray.removeAllObjects()
        searchDeviceTableView.reloadData()
        
        /* Re-Start Searching for Device */
        
        bleManager.stopSearch()
        self.searchDevice()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return scanResultsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        scanResultsCell = (tableView.dequeueReusableCell(withIdentifier: "ScanResultsTableViewCell") as? ScanResultsTableViewCell)!
        
        let deviceInfo : LSDeviceInfo           = scanResultsArray[indexPath.row] as! LSDeviceInfo
        let deviceName : String                 = deviceInfo.deviceName
        let protocolType : String               = deviceInfo.protocolType
        
        scanResultsCell.deviceLabel.text        = "Nom de l'appareil : \(deviceName)"
        scanResultsCell.protocolLabel.text      = "Protocole : \(protocolType)"
        
        scanResultsCell.deviceImageView.image   = ContentUtil.sharedInstance.getDeviceImageByDeviceType(deviceType: deviceInfo.deviceType)
        
        return scanResultsCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let deviceInfo : LSDeviceInfo           = scanResultsArray[indexPath.row] as! LSDeviceInfo
        
        print("device: \(deviceInfo.peripheralIdentifier)")
        
        if deviceInfo.preparePair
        {
            bleManager.stopSearch()
            
            /* ----- PEDOMETER ----- */
            
            if deviceInfo.deviceType == LS_PEDOMETER
            {
                self.setupPedometerUserInfoOnPairingMode()
            }
            
            /* ----- WEIGHING SCALE ----- */
                
            else if deviceInfo.deviceType == LS_WEIGHT_SCALE || deviceInfo.deviceType == LS_FAT_SCALE || deviceInfo.deviceType == LS_KITCHEN_SCALE
            {
                self.setupWeighingScaleUserInfoOnPairingMode()
            }
                
            /* ----- BLOOD PRESSURE ----- */
                
            else if deviceInfo.deviceType == LS_SPHYGMOMETER
            {
                self.setupBloodPressureUserInfoOnPairingMode()
            }
            
            currentWorkingStatus = MANAGER_WORK_STATUS_PAIR
            
            bleManager.pair(with: deviceInfo, pairedDelegate: self)
        }
    }
    
    // MARK: - UIAlertController
    
    func pairingSuccessfulAlert(_ title : String, message : String, protocolType : String)
    {
        pairingSuccessful = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction    = UIAlertAction(title: "OK", style: .default, handler: { action in
        
            self.navigationController?.popViewController(animated: true)
        
        })
        
        pairingSuccessful.addAction(okAction)
        
        DispatchQueue.main.async
        {
            self.present(self.pairingSuccessful, animated: true, completion:{})
        }
    }
    
    func pairingFailedAlert(_ title : String, message : String, protocolType : String)
    {
        pairingFailedAlert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction    = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        pairingFailedAlert.addAction(okAction)
        
        DispatchQueue.main.async
            {
                self.present(self.pairingFailedAlert, animated: true, completion:{})
        }
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if let accountID = UserDefaults.standard.value(forKey: "accountID") as? String
        {
            let memberObj   : MemberObject  = StorageManager.sharedInstance.getMemberInfo(accountID: accountID)
            
            userNumber = buttonIndex + 1
            
            if !memberObj.firstName.isEmpty
            {
                bleManager.bindingDeviceUsers(UInt(userNumber), userName: memberObj.firstName)
            }
            else
            {
                bleManager.bindingDeviceUsers(UInt(userNumber), userName: "Unknown")
            }
        }
    }
    
    // MARK: - Get Current User
    
    func currentDeviceUser() -> AccountObject
    {
        let accountID   = UserDefaults.standard.value(forKey: "accountID") as? String
        let accountObj : AccountObject = StorageManager.sharedInstance.getAccountInfo(accountID: accountID!)
            
        return accountObj
    }
    
    // MARK: - Pedometer Pairing
    
    func setupPedometerUserInfoOnPairingMode()
    {
        let pedometerUserInfo : LSPedometerUserInfo = AppUtil.sharedInstance.getPedometerUserInfo(self.currentDeviceUser())
        
        bleManager.setPedometerUserInfo(pedometerUserInfo)
        
        print("Pedometer User Info On Pairing Mode")
    }
    
    // MARK: - Weighing Scale Pairing
    
    func setupWeighingScaleUserInfoOnPairingMode()
    {
        let productUserInfo : LSProductUserInfo = AppUtil.sharedInstance.getWeighingScaleInfo(self.currentDeviceUser(), userNumber: userNumber)
        
        bleManager.setProductUserInfo(productUserInfo)
        
        print("Product User Info On Pairing Mode")
    }
    
    // MARK: - Blood Pressure Pairing
    
    func setupBloodPressureUserInfoOnPairingMode()
    {
        let productUserInfo : LSProductUserInfo = AppUtil.sharedInstance.getWeighingScaleInfo(self.currentDeviceUser(), userNumber: userNumber)
        
        bleManager.setProductUserInfo(productUserInfo)
        
        print("Product User Info On Pairing Mode")
    }
}

// MARK: - Extension - LSBlePairingDelegate

extension SearchDeviceViewController : LSBlePairingDelegate
{
    func bleManagerDidPairedResults(_ lsDevice: LSDeviceInfo!, pairStatus: Int32)
    {
        if (lsDevice != nil) && pairStatus == Int32(PAIRED_SUCCESS.rawValue)
        {
            /* ----- PEDOMETER ----- */
            
            if lsDevice.deviceType == LS_PEDOMETER
            {
                if !StorageManager.sharedInstance.deviceEntryWithSerialNumExists(deviceSn: lsDevice.deviceSn)
                {
                    let memberObj : MemberObject = StorageManager.sharedInstance.getMemberInfo(accountID: self.currentDeviceUser().accountID)
                    
                    let deviceInfoObj : DeviceObject = AppUtil.sharedInstance.getDeviceInfo(lsDevice)
                    let deviceBindingObj : DeviceBindingObject = AppUtil.sharedInstance.getDeviceBindingInfo(lsDevice, deviceUserNum: 1, memberObj: memberObj)
                    
                    let deviceEntity : DeviceEntity = StorageManager.sharedInstance.addObject(obj: deviceInfoObj) as! DeviceEntity
                    let savedDeviceObj : DeviceObject = StorageManager.sharedInstance.getDeviceManagedObject(deviceManagedObject: deviceEntity)
                    print("deviceObject: \(savedDeviceObj)")
                    
                    let deviceBindingEntity : DeviceBindingEntity = StorageManager.sharedInstance.addObject(obj: deviceBindingObj) as! DeviceBindingEntity
                    let savedDeviceBindingObject : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingManagedObject(deviceBindingManagedObject: deviceBindingEntity)
                    print("deviceBindingObject: \(savedDeviceBindingObject)")
                    
                    self.pairingSuccessfulAlert("Succès", message: "Appareil correctement associé !", protocolType: "A2")
                }
                else
                {
                    /* Device Already Exists */
                    
                    let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: lsDevice.deviceId)
                    
                    deviceBindingObj.broadcast = lsDevice.broadcastId
                    
                    StorageManager.sharedInstance.updateObject(obj: deviceBindingObj)
                    
                    self.pairingFailedAlert("Echec", message: "L'association de l'appareil a échoué", protocolType: "A2")
                }
            }
                
           /* ----- WEIGHING SCALE ----- */
                
            else if lsDevice.deviceType == LS_WEIGHT_SCALE || lsDevice.deviceType == LS_FAT_SCALE || lsDevice.deviceType == LS_KITCHEN_SCALE
            {
                bleManager.addMeasureDevice(lsDevice)
                
                if !StorageManager.sharedInstance.deviceEntryWithSerialNumExists(deviceSn: lsDevice.deviceSn)
                {
                    /* Device Doesn't Exist */
                    
                    lsDevice.deviceUserNumber = UInt(userNumber)
                    
                    let memberObj : MemberObject = StorageManager.sharedInstance.getMemberInfo(accountID: self.currentDeviceUser().accountID)
                    
                    let deviceInfoObj : DeviceObject = AppUtil.sharedInstance.getDeviceInfo(lsDevice)
                    let deviceBindingObj : DeviceBindingObject = AppUtil.sharedInstance.getDeviceBindingInfo(lsDevice, deviceUserNum: userNumber, memberObj: memberObj)
                    
                    let deviceEntity : DeviceEntity = StorageManager.sharedInstance.addObject(obj: deviceInfoObj) as! DeviceEntity
                    let savedDeviceObj : DeviceObject = StorageManager.sharedInstance.getDeviceManagedObject(deviceManagedObject: deviceEntity)
                    print("deviceObject: \(savedDeviceObj)")
                    
                    let deviceBindingEntity : DeviceBindingEntity = StorageManager.sharedInstance.addObject(obj: deviceBindingObj) as! DeviceBindingEntity
                    let savedDeviceBindingObject : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingManagedObject(deviceBindingManagedObject: deviceBindingEntity)
                    print("deviceBindingObject: \(savedDeviceBindingObject)")
                    
                    /* Call API */
                    
                    self.addDeviceToServer("A3")
                }
                else
                {
                    /* Device Already Exists */
                    
                    let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: lsDevice.deviceId)
                    
                    deviceBindingObj.broadcast = lsDevice.broadcastId
                    
                    StorageManager.sharedInstance.updateObject(obj: deviceBindingObj)
                    
                    self.pairingFailedAlert("Echec", message: "L'association de l'appareil a échoué", protocolType: "A3")
                }
            }
                
            /* ----- BLOOD PRESSURE ----- */
                
            else if lsDevice.deviceType == LS_SPHYGMOMETER
            {
                bleManager.addMeasureDevice(lsDevice)
                
                if !StorageManager.sharedInstance.deviceEntryWithSerialNumExists(deviceSn: lsDevice.deviceSn)
                {
                    lsDevice.deviceUserNumber = UInt(userNumber - 1)
                    
                    let memberObj : MemberObject = StorageManager.sharedInstance.getMemberInfo(accountID: self.currentDeviceUser().accountID)
                    
                    let deviceInfoObj : DeviceObject = AppUtil.sharedInstance.getDeviceInfo(lsDevice)
                    let deviceBindingObj : DeviceBindingObject = AppUtil.sharedInstance.getDeviceBindingInfo(lsDevice, deviceUserNum: userNumber - 1, memberObj: memberObj)
                    
                    let deviceEntity : DeviceEntity = StorageManager.sharedInstance.addObject(obj: deviceInfoObj) as! DeviceEntity
                    let savedDeviceObj : DeviceObject = StorageManager.sharedInstance.getDeviceManagedObject(deviceManagedObject: deviceEntity)
                    print("deviceObject: \(savedDeviceObj)")
                    
                    let deviceBindingEntity : DeviceBindingEntity = StorageManager.sharedInstance.addObject(obj: deviceBindingObj) as! DeviceBindingEntity
                    let savedDeviceBindingObject : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingManagedObject(deviceBindingManagedObject: deviceBindingEntity)
                    print("deviceBindingObject: \(savedDeviceBindingObject)")
                    
                    self.pairingSuccessfulAlert("Succès", message: "Appareil correctement associé !", protocolType: "A2")
                }
                else
                {
                    /* Device Already Exists */
                    
                    let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: lsDevice.deviceId)
                    
                    deviceBindingObj.broadcast = lsDevice.broadcastId
                    
                    StorageManager.sharedInstance.updateObject(obj: deviceBindingObj)
                    
                    self.pairingFailedAlert("Echec", message: "L'association de l'appareil a échoué", protocolType: "A2")
                }
            }
        }
        else
        {
            self.pairingFailedAlert("Echec", message: "L'association de l'appareil a échoué", protocolType: "A3")
        }
    }
    
    func bleManagerDidDiscoverUserList(_ userlist: [AnyHashable : Any]!)
    {
        DispatchQueue.main.async
        {
            self.showUserList = UIActionSheet.init(title: "Tous les utilisateurs", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
            
            for (tempKey,userName) in Array(userlist).sorted(by: {$0.0.description < $1.0.description})
            {
                print("\(tempKey):\(userName)")
                
                var userNameString : String = userName as! String
                
                if (userNameString == "" || userNameString == "unknowName")
                {
                    userNameString = "Unknown"
                }
                
                let strList : String = "\(tempKey)-----\(userNameString)"
                
                self.showUserList.addButton(withTitle: strList)
            }
            
            self.showUserList.show(in: self.view)
        }
    }
}

// MARK: - Extension - WebServiceManagerDelegate

extension SearchDeviceViewController : WebServiceManagerDelegate
{
    func addDeviceToServer(_ protocolType : String)
    {
        manager.delegate = self
        manager.addDeviceToServer(protocolType)
    }
    
    func bindDeviceToServer(_ protocolType : String)
    {
        let deviceObj           : DeviceObject          = StorageManager.sharedInstance.getDeviceByProtocolType(protocolType: protocolType)
        let deviceBindingObj    : DeviceBindingObject   = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: deviceObj.deviceID)
        
        deviceBindingObj.deviceUserNo = userNumber
        StorageManager.sharedInstance.updateObject(obj: deviceBindingObj)
        
        manager.delegate = self
        manager.bindDeviceToServer([deviceBindingObj])
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
        self.bindDeviceToServer(protocolType)
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceFailed error: NSString, protocolType: String)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceSuccess success: NSString)
    {
        /* Show an alert */
        
        self.pairingSuccessfulAlert("Succès", message: "Appareil correctement associé !", protocolType: "A3")
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceFailed error: NSString)
    {
        
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
