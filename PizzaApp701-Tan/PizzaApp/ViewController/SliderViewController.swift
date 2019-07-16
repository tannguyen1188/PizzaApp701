//
//  SliderViewController.swift
//  PizzaApp
//
//  Created by mac on 7/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    //UserDefaults - Persistence - UserSettings, Flags - Strings, Ints, Booleans, Data, Arrays
    
    @IBOutlet weak var pizzaSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        

    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        let value = Int(pizzaSlider.value)
        sliderLabel.text = "Pizza Count: \(value)"
        UserDefaults.standard.set(value, forKey: "slider")
    }
    
   
    func setupSlider() {
        
        if let value = UserDefaults.standard.value(forKey: "slider") as? Int {
            
            sliderLabel.text = "Pizza Count: \(value)"
            pizzaSlider.value = Float(value)
        }
    }
    
    
    
}
