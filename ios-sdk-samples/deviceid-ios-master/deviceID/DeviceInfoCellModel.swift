//
//  DeviceIDModel.swift
//  deviceID
//
//  Created by Bharath Natarajan on 26/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation

enum DeviceInfoType {
    case idfa
    case idfv
    case ipAddress
}

class DeviceInfoCellModel: NSObject {
    let type: DeviceInfoType
    let title: String
    var value: String
    let definition: String
    
    init(with type: DeviceInfoType, title: String, value: String, definition: String) {
        self.type = type
        self.title = title
        self.value = value
        self.definition = definition
    }
}
