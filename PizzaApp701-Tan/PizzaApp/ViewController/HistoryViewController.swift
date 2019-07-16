//
//  HistoryViewController.swift
//  PizzaApp
//
//  Created by Consultant on 7/15/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var orderedPizzas: [Pizza] {
        return PizzaManager.shared.loadPizzas()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.reloadData()
    }
}
extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedPizzas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOrderCell") as! HistoryViewCell
        
        let pizza = orderedPizzas[indexPath.row]
        cell.setLabel(with: pizza)
        
        
        return cell
    }
    
}



extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
