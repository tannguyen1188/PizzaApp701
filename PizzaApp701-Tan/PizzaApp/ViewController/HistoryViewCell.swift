//
//  HistoryViewCell.swift
//  PizzaApp
//
//  Created by Consultant on 7/15/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {

    @IBOutlet weak var PizzaLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    func setLabel(with oPizza: Pizza) {
        PizzaLabel.text = oPizza.toppings.joined(separator: ", ") //Pepperoni, Sausage
        PriceLabel.text = "Price: \(oPizza.price!)"
    }
}
