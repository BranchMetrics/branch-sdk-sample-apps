//
//  DeviceInfoself.swift
//  deviceID
//
//  Created by Bharath Natarajan on 28/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfoCell: UITableViewCell {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var extraBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formatCell()
    }
    
    func formatCell(){
        self.title.font = UIFont(name:"HelveticaNeue-Medium", size: 18.0)
        self.title.textColor = HomeViewController.branchColor
        
        self.value.font = UIFont(name:"HelveticaNeue", size: 18.0)
        self.value.textColor = UIColor.darkGray
        self.value.layer.cornerRadius = 5
        self.value.layer.masksToBounds = true
        
        self.infoView.layer.cornerRadius = 23
        self.infoView.layer.masksToBounds = true
        
        self.extraBtn.layer.cornerRadius = 20
        self.copyBtn.layer.cornerRadius = 20
        self.shareBtn.layer.cornerRadius = 20
        
        self.extraBtn.showsTouchWhenHighlighted = true
        self.extraBtn.setTitleColor(HomeViewController.branchColor, for: .selected)
        
        self.copyBtn.showsTouchWhenHighlighted = true
        self.copyBtn.setTitleColor(HomeViewController.branchColor, for: .selected)
        
        self.shareBtn.showsTouchWhenHighlighted = true
        self.shareBtn.setTitleColor(UIColor.lightGray, for: .selected)
        
        self.infoBtn.showsTouchWhenHighlighted = true
        self.infoBtn.setTitleColor(UIColor.lightGray, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


