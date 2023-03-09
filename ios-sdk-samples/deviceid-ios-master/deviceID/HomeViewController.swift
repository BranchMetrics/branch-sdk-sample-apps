//
//  HomeViewController.swift
//  deviceID
//
//  Created by Bharath Natarajan on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import AdSupport
import QuartzCore
import SafariServices
import Branch
import Foundation
import AppTrackingTransparency


class HomeViewController: UIViewController, SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var deviceInfoTable: UITableView!
    @IBOutlet weak var deviceNameView: UIView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceModel: UILabel!
    @IBOutlet weak var shareAll: UIButton!
    
    //Constants
    static let branchColor: UIColor = UIColor(red: 0/255.0, green: 117/255.0, blue: 201/255.0, alpha: 1.0)
    var branchDeviceInfo = BNCDeviceInfo()
    var infoModel:[DeviceInfoCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.deviceInfoTable.delegate = self
        self.deviceInfoTable.dataSource = self
        
        branchDeviceInfo = BNCDeviceInfo()
        formatDeviceInfoView()
        populateInfoModel()

        self.updateIDFA()
        self.updateIPAddress()
        
        sendPurchaseEvent(alias: "VIEW_LOAD")
        
        let branch = Branch.getInstance()
        branch.nativeComputeDebugCallback = { [self] viewController, error in
            if let viewController = viewController {
                present(viewController, animated: true) {
                }
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func shareAction(sender: UIButton) {
        let shareTag = sender.tag
        showShareSheet(withItems: [infoModel[shareTag].value])
        // Track custom share event
        BranchEvent.customEvent(withName: "Share " + infoModel[shareTag].title).logEvent()
    }
    
    @IBAction func shareAllAction(_ sender: Any) {
        var shareText = ""
        for info in infoModel {
            shareText = shareText + info.title + " : " + info.value + "\n"
        }
        showShareSheet(withItems: [shareText])
        sendPurchaseEvent(alias: "SHARE_ALL")
    }
    
    @IBAction func learnMoreAction(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://branch.io")! as URL)
        
        if #available(iOS 10, *) {
            safariVC.preferredBarTintColor = HomeViewController.branchColor
        }
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }

    @IBAction func viewPrivacyPolicy(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://branch.io/policies/privacy-policy/")! as URL)
        
        if #available(iOS 10, *) {
            safariVC.preferredBarTintColor = HomeViewController.branchColor
        }
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    

    
    @objc func copyAction(sender: UIButton) {
        let copyTag = sender.tag
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = infoModel[copyTag].value
        
        let message = "Copied \(infoModel[(sender as AnyObject).tag].title) to clipboard"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            alert.dismiss(animated: true)
        }
        // Track custom copy event
        BranchEvent.customEvent(withName: "Copy " + infoModel[copyTag].title).logEvent()
    }
    
    @objc func infoAction(sender: UIButton) {
        let infoTag = sender.tag
        let infoTitle = infoModel[infoTag].title
        showAlert(withTitle: infoTitle, andMessage: infoModel[infoTag].definition)
        // Track standard VIEW_ITEM event
        let branchUniversalObject = BranchUniversalObject.init()
        branchUniversalObject.title = infoTitle
        branchUniversalObject.contentMetadata.price = 2.0
        branchUniversalObject.contentMetadata.currency = .USD
        branchUniversalObject.contentMetadata.sku = "123"

        let event = BranchEvent.standardEvent(.viewItem)
        event.contentItems = [ branchUniversalObject ]
        event.eventDescription = "View \(infoTitle) Info Modal"
        event.revenue = 2.0
        event.customData = [ "my_title": infoTitle ]
        event.logEvent()
    }
    
    //TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = infoModel[indexPath.row]
        let cell:DeviceInfoCell = self.deviceInfoTable.dequeueReusableCell(withIdentifier: "info") as! DeviceInfoCell

        cell.extraBtn.tag = indexPath.row
        cell.copyBtn.tag = indexPath.row
        cell.shareBtn.tag = indexPath.row
        cell.infoBtn.tag = indexPath.row
        
        cell.copyBtn.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        cell.shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        cell.infoBtn.addTarget(self, action: #selector(infoAction), for: .touchUpInside)
        
        cell.title.text = model.title
        cell.value.text = model.value
        
        if (model.type == .idfa) {
            cell.extraBtn.isHidden = false
            cell.extraBtn.addTarget(self, action: #selector(requestIDFA), for: .touchUpInside)
        } else if (model.type == .ipAddress) {
            cell.extraBtn.isHidden = false
            cell.extraBtn.addTarget(self, action: #selector(updateIPAddress), for: .touchUpInside)
        } else {
            cell.extraBtn.isHidden = true
        }

        return cell
    }
    
    // Helper methods
    func formatDeviceInfoView(){
        deviceName.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        deviceName.textColor = UIColor.darkGray
        
        deviceModel.font = UIFont(name:"HelveticaNeue-Light", size: 20.0)
        deviceModel.textColor = UIColor.darkGray
        
        deviceNameView.layer.cornerRadius = 15
        
        deviceName.text = UIDevice.current.name
        deviceModel.text = UIDevice.modelName
        shareAll.layer.cornerRadius = 25
    }
    
    func showShareSheet(withItems items:[String]){
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showAlert(withTitle title:String, andMessage message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func populateInfoModel(){
        infoModel = []
        let idfaData = DeviceInfoCellModel(with: .idfa, title: "Advertising ID (IDFA)", value: "", definition: "IDFA is an identifier for advertisers provided by Apple, it is the same for all apps on a device. If access is granted by the end user, IDFA allows mobile advertising networks to track users and serve targeted ads.")
        
        let idfvData = DeviceInfoCellModel(with: .idfv, title: "Vendor ID (IDFV)", value: branchDeviceInfo.vendorId ?? "00000000-0000-0000-0000-000000000000", definition: "IDFV is an identifier for app vendors provided by Apple, it is the same for all apps from the same vendor on a device. Different vendors get different IDFVs on the same device.")
        
        let ipAddressData = DeviceInfoCellModel(with: .ipAddress, title: "IP Address", value: "", definition: "An IP address is an identifying number for a device connected to a network. This device IP address is from the point of view of a public website. https://api.ipify.org")
        
        infoModel.append(idfaData)
        infoModel.append(idfvData)
        infoModel.append(ipAddressData)
    }
    
    // update IDFA
    func updateIDFA() {
        for info in infoModel {
            if (info.type == .idfa) {
                branchDeviceInfo.checkAdvertisingIdentifier()
                if (branchDeviceInfo.advertiserId != nil && branchDeviceInfo.advertiserId != "00000000-0000-0000-0000-000000000000") {
                    info.value = branchDeviceInfo.advertiserId
                } else {
                    info.value = branchDeviceInfo.optedInStatus
                }
                
                self.deviceInfoTable.reloadData()
            }
        }
    }
    
    // request IDFA via ATT
    @objc func requestIDFA(sender: UIButton) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                if (status == .authorized) {
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier
                    print("IDFA: " + idfa.uuidString)
                } else {
                    print("Failed to get IDFA")
                }
                DispatchQueue.main.async {
                    self.updateIDFA()
                }
            }
        }
    }
    
    // update IP address
    @objc func updateIPAddress() {
        for info in infoModel {
            if (info.type == .ipAddress) {
                self.updateModelWithIPAddress(info: info)
            }
        }
    }
    
    // fetch public IP Address and update model async
    func updateModelWithIPAddress(info: DeviceInfoCellModel) {
        info.value = "loading..."
        self.deviceInfoTable.reloadData()
        
        DispatchQueue.global().async {
            do {
                if let url = URL(string: "https://api.ipify.org") {
                    let ipAddress = try String(contentsOf: url)
                    DispatchQueue.main.async {
                        info.value = ipAddress
                        self.deviceInfoTable.reloadData()
                    }
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    info.value = "Server did not respond"
                    self.deviceInfoTable.reloadData()
                }
            }
        }
    }
    
    // Track standard PURCHASE event
    func sendPurchaseEvent(alias: String){
        let revenueList: [NSDecimalNumber] = [4, 8, 12, 16, 32]
        let event = BranchEvent.standardEvent(.purchase)
        event.alias = alias
        event.transactionID = String(Int(Date().timeIntervalSince1970))
        event.currency = .USD
        event.revenue = revenueList.randomElement()
        event.logEvent()

    }
}
