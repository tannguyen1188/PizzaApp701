//
//  Pizza.swift
//  PizzaApp
//
//  Created by mac on 7/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


class Pizza {
    
    let toppings: [String]
    let price: Int?
    
    
    init(json: [String:Any]) {
        
        self.toppings = json["toppings"] as! [String]
        self.price = json["price"] as? Int ?? Int.random(in: 1...30) //nil coalescing, give's default value to an optional
        
    }
    
    init(from core: CorePizza) {
        self.toppings = core.value(forKey: "toppings") as! [String]
        self.price = Int.random(in: 1...30)
    }
    
    init(toppings: [String], price: Int?) {
        self.toppings = toppings
        self.price = price
    }
    
}
