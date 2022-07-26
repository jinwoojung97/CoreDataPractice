//
//  PersistenceManager.swift
//  CoreDataPractice
//
//  Created by inforex on 2022/07/22.
//

import Foundation
import CoreData

class PersistanceManager {
    static var shared: PersistanceManager = PersistanceManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext{
        return self.persistentContainer.viewContext
    }
    
    //MARK: 저장하기 Contact만을 위한 메소드
    @discardableResult
    func insertPerson(person: Person) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: self.context)
        
        if let entity = entity {
             let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            managedObject.setValue(person.name, forKey: "name")
            managedObject.setValue(person.phoneNumber, forKey: "phoneNumber")
            managedObject.setValue(person.shortcutNumber, forKey: "shortcutNumber")
            managedObject.setValue(person.habbit, forKey: "habbit")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    //MARK: 저장된 데이터 fetch
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    //MARK: 특정 object삭제
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    //MARK: 전체 삭제
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try self.context.execute(delete)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
