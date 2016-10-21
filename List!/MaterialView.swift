//
//  MaterialView.swift
//  List!
//
//  Created by Allan Wallace on 20/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//



import UIKit

class MaterialView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor(red: SHADOW_COLOUR, green: SHADOW_COLOUR, blue: SHADOW_COLOUR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 12.0
        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        
        
    }
    
}
