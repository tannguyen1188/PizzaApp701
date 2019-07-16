//
//  ViewController.swift
//  PizzaApp
//
//  Created by mac on 7/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PizzaViewController: UIViewController {
    
    @IBOutlet weak var pizzaTableView: UITableView!
    
    //DidSet and WillSet, are called property observers
    var pizzas = [Pizza]() {
        //called BEFORE the value is changed
        willSet {
            
        }
        //didSet is called AFTER the value is changed
        didSet {
            pizzaTableView.reloadData()
        }
    }
    
    var storedPizzas: [Pizza] {
        return PizzaManager.shared.loadPizzas()
    }
    
    //computed property - will compute value everytime the property is called
    var pizzaLimit: Int {
        return UserDefaults.standard.value(forKey: "slider") as? Int ?? 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pizzaTableView.estimatedRowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         //closures almost always cause retain cycles - escaping closure having a seperate life span than the function it resides in
        
        PizzaManager.shared.getPizza(with: pizzaLimit) { [unowned self] pizza in
            if let pies = pizza {
                self.pizzas = pies
                self.storedPizzas.forEach({self.pizzas.insert($0, at: 0)})
                print("Pizza Count: \(self.pizzas.count)")
            }
        }
        
        
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        

        let sliderVC = storyboard?.instantiateViewController(withIdentifier: "SliderViewController") as! SliderViewController
        
        //hide tab bar when pushed onto stack
        sliderVC.hidesBottomBarWhenPushed = true
        //stop flickering when pushing to a new VC
        navigationController?.view.backgroundColor = UIColor.white
        //navigation controller add VC to stack
        navigationController?.pushViewController(sliderVC, animated: true)
    }
    


}


//MARK: TableView

extension PizzaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PizzaTableCell.identifier, for: indexPath) as! PizzaTableCell
        
        let pizza = pizzas[indexPath.row]
        cell.configure(with: pizza)
        
        
        return cell
    }
    
}



extension PizzaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
