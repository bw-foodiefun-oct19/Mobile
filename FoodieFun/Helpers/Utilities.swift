//
//  Utilities.swift
//  FoodieFun
//
//  Created by John Kouris on 10/19/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class Utilities {
    
    static func styleFilledButton(_ button: UIButton) {
        button.backgroundColor = UIColor.init(red: 231/255, green: 111/255, blue: 37/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 231/255, green: 111/255, blue: 37/255, alpha: 1).cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
}
