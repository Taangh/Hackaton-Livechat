//
//  Pattern.swift
//  chatHackaton
//
//  Created by Damian on 24.03.2018.
//  Copyright © 2018 Damian. All rights reserved.
//

import Foundation

class Pattern: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(path, forKey: "path")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let path = aDecoder.decodeObject(forKey: "path") as! [Int]
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(name: name, path: path)
        
    }
    
    let name: String
    let path: [Int]
    
    init(name: String, path: [Int]) {
        self.name = name
        self.path = path
    }
}
