//
//  CustomTableViewCell.swift
//  Documents
//
//  Created by Grant Maloney on 8/26/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var documentTitle: UILabel!
    
    @IBOutlet weak var documentSize: UILabel!
    
    @IBOutlet weak var dateModified: UILabel!
}
