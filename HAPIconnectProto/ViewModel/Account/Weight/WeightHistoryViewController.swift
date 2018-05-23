//
//  WeightHistoryViewController.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/15/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class WeightHistoryViewController: UITableViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet var weightDataTableView   : UITableView!
    
    // MARK: - Variables
    
    var displayWeightCell               = DisplayWeightTableViewCell()
    
    var manager : WebServiceManager     = WebServiceManager()
    
    var weightRecordArray               = [WeightRecordObject]()
    
    var weightDate                      = String()
    var deviceObj                       = DeviceObject()
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Remove TableView Footer */
        
        weightDataTableView.tableFooterView = UIView(frame: .zero)
        
        /* Content */
        
        self.loadContent()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load Content
    
    func loadContent()
    {
        weightRecordArray           = StorageManager.sharedInstance.getWeightRecordArrayByDeviceIDAndDate(deviceID: deviceObj.deviceID, weightDate: weightDate)
    }
    
    // MARK: - Button Actions
    
    @IBAction func syncDataToServiceButtonTapped(_ sender: UIBarButtonItem)
    {
        if !(UserDefaults.standard.string(forKey: "sessionId")?.isEmpty)! && !(UserDefaults.standard.string(forKey: "accessToken")?.isEmpty)!
        {
            for weightRecordObj in weightRecordArray
            {
                if weightRecordObj.weight_state != WeightRecordObject.WEIGHTSTATE.WEIGHT_SYNC
                {
                    self.updateWeightRecord(weightRecordObj)
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weightRecordArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        displayWeightCell = (tableView.dequeueReusableCell(withIdentifier: "DisplayWeightTableViewCell") as? DisplayWeightTableViewCell)!
        
        let weightRecordObj : WeightRecordObject = weightRecordArray[indexPath.row]
        
        let timeImage : UIImage?
        
        if CalendarUtil.sharedInstance.checkIfAMorPM(weightRecordObj.measurementDateTimeStamp) == "AM"
        {
            timeImage = UIImage(named: "am_icon")
        }
        else
        {
            timeImage = UIImage(named: "pm_icon")
        }
        
        displayWeightCell.timeImageView.image       = timeImage
        
        let dateArray                               = weightRecordObj.measurementDate.components(separatedBy: " ")
        let getTimeFromArray : String               = dateArray.last!
        
        displayWeightCell.timeLabel.text            = "\(CalendarUtil.sharedInstance.getTimeAMPMFromString(getTimeFromArray))"
        
        displayWeightCell.weightValueLabel.text     = String(format: "%.1f kg", weightRecordObj.weightValue)
        displayWeightCell.bodyFatPercentageLabel.text = String(format: "%.1f %%", weightRecordObj.pbfValue)
        displayWeightCell.leanMassLabel.text        =  String(format: "%.1f %%", weightRecordObj.muscleValue)
        
        displayWeightCell.waterWeightLabel.text     = String(format: "%.1f %%", weightRecordObj.bodyWaterValue)
        displayWeightCell.boneMassLabel.text        = String(format: "%.1f kg", weightRecordObj.boneValue)
        displayWeightCell.bodyMassIndexLabel.text   = String(format: "%.1f", weightRecordObj.bmiValue)
        
        displayWeightCell.setWeightRecordAccessoryType(weightRecordObj)
        
        return displayWeightCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let weightRecordObj : WeightRecordObject = weightRecordArray[indexPath.row]
            self.deleteWeightData(weightRecordObj)
            
            DispatchQueue.main.async
            {
                self.weightDataTableView.reloadData()
            }
        }
    }
}

// MARK: - Extension - WebServiceManagerDelegate

extension WeightHistoryViewController : WebServiceManagerDelegate
{
    func updateWeightRecord(_ weightRecordObj : WeightRecordObject)
    {
        manager.delegate = self
        manager.saveWeight(weightRecordObj)
    }
    
    func deleteWeightData(_ weightRecordObj : WeightRecordObject)
    {
        manager.delegate = self
        manager.deleteWeight(weightRecordObj)
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
        DispatchQueue.main.async
        {
            self.weightDataTableView.reloadData()
        }
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightSuccess success : NSString)
    {
        /* Content */
        
        self.loadContent()
        
        /* Reload TableView */
        
        DispatchQueue.main.async
        {
            self.weightDataTableView.reloadData()
        }
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
