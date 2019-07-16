//
//  OrderViewController.swift
//  PizzaApp
//
//  Created by mac on 7/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var orderPickerView: UIPickerView!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    var toppings = ["Pepperoni", "Goat", "Goat Cheese", "Italian Sausage", "Duck", "Chicken", "Mushrooms", "Green Peppers", "Pineapple", "Ham", "Bacon", "Extra Cheese"].sorted() {
        didSet {
            orderPickerView.reloadAllComponents()
        }
    }
    
    var selectedToppings = [String]() {
        didSet {
            orderTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Are you sure?", message: selectedToppings.joined(separator: ", "), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            
            PizzaManager.shared.savePizza(self.selectedToppings)
            
            for topping in self.selectedToppings {
                self.toppings.append(topping)
            }
          
            self.toppings.sort()
            self.selectedToppings.removeAll()
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        
        orderTableView.isEditing.toggle()
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        guard !toppings.isEmpty else {
            return
        }
        
        let row = orderPickerView.selectedRow(inComponent: 0)
        
        let topping = toppings[row]
        
        toppings.remove(at: row)
        
        toppings.sort()
        
        selectedToppings.append(topping)
        
        
        print("selected topping: \(topping)")
        
    }
    
    

}

//MARK: TableView
extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedToppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        }
        
        let topping = selectedToppings[indexPath.row]
        cell.textLabel?.text = topping
        
        return cell
    }
    
    
    
    
}


extension OrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            let topping = selectedToppings[indexPath.row]
            toppings.append(topping)
            toppings.sort()
            
            selectedToppings.remove(at: indexPath.row)
            
        default:
            break
        }
    }
    
    
    
}


//MARK: PickerView

extension OrderViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toppings.count
    }
    
}


extension OrderViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toppings[row]
    }
    
}
