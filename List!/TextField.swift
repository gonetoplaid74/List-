//
//  TextField.swift
//  List!
//
//  Created by Allan Wallace on 20/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: SHADOW_COLOUR, green: SHADOW_COLOUR, blue: SHADOW_COLOUR, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
        
    }
    //for placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    // for editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
