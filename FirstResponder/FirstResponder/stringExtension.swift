//
//  stringExtension.swift
//  FirstResponder
//
//  Created by Jonas Deichelmann on 26.11.17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import Foundation
//MARK: - STRING EXTENSION
extension String{
    
    var length : Int{
        return self.characters.count
    }
    
    var isUserName:Bool{
        let s = self
        if s.characters.count > 5 && s.characters.count < 63 {
            return true
        }
        else {
            return false
        }
    }
    var isEmail : Bool {
        return true
    }
}
