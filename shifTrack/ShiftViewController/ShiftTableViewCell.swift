//
//  ShiftTableViewCell.swift
//  shifTrack
//
//  Created by Leonid Rusnac on 10/11/15.
//  Copyright © 2015 Leonid Rusnac. All rights reserved.
//

import UIKit

class ShiftTableViewCell: UITableViewCell {

    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setShiftViewCell(shift: Shift) {
        let dateFormatter = NSDateFormatter() // move out of here, it's not good to create a formatter for every cell
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        self.startTime.text! = dateFormatter.stringFromDate(shift.startTime!) // TODO
        
        if let endTime = shift.finishTime {
            self.endTime.text! = dateFormatter.stringFromDate(endTime)
        } else {
            self.endTime.text! = "not finished"
        }

    }
}
