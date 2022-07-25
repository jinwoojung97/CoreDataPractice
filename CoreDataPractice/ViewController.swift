//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by inforex on 2022/07/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        coreData()
//        fetchContact()
//        insertPerson()
//        deleteAll()
//        deletePerson()

        fetch()
    }
    
    func coreData(){
        let jinwoo = Person(name: "juHoon", phoneNumber: "15513212", shortcutNumber: 1, habbit: ["1", "2", "3", "4"])
        
        //MARK:  1.NSManagedObjectContext를 가져온다
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //MARK:  2.entity를 가져온다. 가져온 entity에 저장을 해야 하기 때문
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        
        //MARK:  3.NSManagedObject를 만든다.
        if let entity = entity{
            let person = NSManagedObject(entity: entity, insertInto: context)
            //MARK:  4.NSManagedObject에 값을 세팅해준다.
            person.setValue(jinwoo.name, forKey: "name")
            person.setValue(jinwoo.phoneNumber, forKey: "phoneNumber")
            person.setValue(jinwoo.shortcutNumber, forKey: "shortcutNumber")
            
            //MARK:  5.NSManagedObjectContext를 저장해준다.
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchContact(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let contact = try context.fetch(Contact.fetchRequest()) as! [Contact]
            contact.filter{$0.name == "juHoon"}.map{print($0.phoneNumber)}
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: 저장된 데이터 fetch
    func fetch(){
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let fetchResult = PersistanceManager.shared.fetch(request: request)
        
        fetchResult.forEach{
            print($0.habbit?.first)
        }
        
        if fetchResult.isEmpty{
            print("비어있음")
        }
    }
    
    //MARK: 저장하기
    func insertPerson(){
        for i in 0..<10{
            let sangGab = Person(name: "yeonhak\(i)", phoneNumber: "010-4564-456\(i)", shortcutNumber: i, habbit: ["1", "2", "3", "4"])
            
            PersistanceManager.shared.insertPerson(person: sangGab)
        }
        
        
    }
    
    //MARK: 특정 object 삭제 (마지막)
    func deletePerson(){
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        let fetchResult = PersistanceManager.shared.fetch(request: request)
        
//        let jinwoo1 = fetchResult.filter{$0.name == "jinwoo1"}.first! // 조건 삭제
        
        PersistanceManager.shared.delete(object: fetchResult.last!)
    }
    
    //MARK: 전체 삭제
    func deleteAll(){
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        PersistanceManager.shared.deleteAll(request: request)
        
        let arr = PersistanceManager.shared.fetch(request: request)
        
        if arr.isEmpty{
            print("clean")
        }
    }
    

}


struct Person {
    
    var name : String
    var phoneNumber : String
    var shortcutNumber : Int
    var habbit : [String]
}
