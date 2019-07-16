//
//  PizzaManager.swift
//  PizzaApp
//
//  Created by mac on 7/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreData

/*
 Core Data Stack
 
 1. NSManagedObjectContext - Where all the entities are created, You MUST save context to persist the data
 2. NSPersistentContainer - Where all the entities are stored
 3. NSManagedObject - Objects of CoreData (entities)
 4. NSPersistentCoordinator - Coordinate manages how the entities are saved
 
 Notes:
 CoreData is NOT thread safe
 */

typealias PizzaHandler = ([Pizza]?) -> Void

//Singleton - Is a single instance of an object in the applications life.

//1. does not allow inheritance
final class PizzaManager {
    
    
    //2. we need a shared instance - for access
    //static variables are global variables (can be used throughout application) and do not need a instance to access them
    static let shared = PizzaManager()
    
    //3. a private initialize - so no one else can create an instance outside of the declaration
    private init() {}
    
    
    //NSManagedObjectContext
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //PersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PizzaApp")
        
        container.loadPersistentStores(completionHandler: { (store, err) in
            if let error = err {
                fatalError()
            }
        })
        
        return container
    }()
    
    
    //MARK: Core Data Helpers
    
    func savePizza(_ toppings: [String]) {
        
        
        //create an entity description
        let entity = NSEntityDescription.entity(forEntityName: "CorePizza", in: context)!
        
        
        //initialize an entity
        let pizza = NSManagedObject(entity: entity, insertInto: context)
        
        
        //set values - KVC (Key Value Coding) - accessing an object's properties by strings
        pizza.setValue(toppings, forKey: "toppings")
        
        
        print("Saved Pizza: \(pizza.value(forKey: "toppings") as! [String])")
        
        //save the context
        saveContext()
        
    }
    
   
    func loadPizzas() -> [Pizza] {
        
        //Fetch Request - access CoreData entities
        let fetchRequest = NSFetchRequest<CorePizza>(entityName: "CorePizza")
        
        
        do {
            let corePizzas = try context.fetch(fetchRequest)
            let pizzas = corePizzas.map({Pizza(from: $0)})
            print("Stored Pizzas: \(pizzas.count)")
            return pizzas
        } catch {
            print("Couldn't fetch pizzas: \(error.localizedDescription)")
        }
        
        
        return []
    }
    
    
    
    
    private func saveContext() {
        do {
           try context.save()
        } catch {
            fatalError()
        }
    }
    
    
    
    //closures - are nameless blocks of functionality, that can be used to capture values asynchronously
    //escaping closure - closure has a seperate life span than the function that it resides in, allows for asynchronous call backs
    
    func getPizza(with limit: Int = 100, completion: @escaping PizzaHandler) {
        
        //GCD - Grand Central Dispatch - Native API used for basic multithreading
        //QOS - quality of service - priority of the queue -
        //1. userinitiated, 2. userinteractive, 3. default, 4. utility, 5. background
        
        DispatchQueue.global(qos: .utility).async {
            
            guard let path = Bundle.main.path(forResource: "pizzas", ofType: "json") else {
                completion(nil)
                return
            }
            
            let pizzaURL = URL(fileURLWithPath: path)
            
            var pizzas = [Pizza]()
            
            do {
                let data = try Data(contentsOf: pizzaURL)
                
                if let pizzaJson = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                    
                    
                    for index in 0..<limit {
                        let pizzaDict = pizzaJson[index]
                        let pizza = Pizza(json: pizzaDict)
                        pizzas.append(pizza)
                    }
    
                    
                    //go back to main thread for completion
                    DispatchQueue.main.async {
                        completion(pizzas)
                    }
                }
                
            } catch {
                
                print("Couldn't make pizzas: \(error.localizedDescription)")
                
            }
            
        }
    } //end func
    
    
    
    
    
    
}//end class
