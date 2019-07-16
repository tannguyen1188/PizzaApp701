//
//  PizzaTableCell.swift
//  PizzaApp
//
//  Created by mac on 7/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PizzaTableCell: UITableViewCell {

    @IBOutlet weak var pizzaMainLabel: UILabel!
    @IBOutlet weak var pizzaSubLabel: UILabel!
    
    static let identifier = "PizzaTableCell"
    
    
    func configure(with pizza: Pizza) {
        pizzaMainLabel.text = pizza.toppings.joined(separator: ", ") //Pepperoni, Sausage
        pizzaSubLabel.text = "Price: \(pizza.price!)"
    }

}
