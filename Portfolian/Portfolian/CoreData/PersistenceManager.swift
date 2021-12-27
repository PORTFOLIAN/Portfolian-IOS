//
//  PersisteneceManager.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/23.
//

import Foundation
import CoreData
struct Person {
    var title: String?
    var tags: [String]?
    var teamTags: [String]?
    var recruit: Int?
    var period: String?
    var explain: String?
    var option: String?
    var proceed: String?
    var detail: String?
}
struct JwtToken {
    var accessToken: String?
    var refreshToken: String?
    var userId: String?
}
class PersistenceManager {

    static var shared: PersistenceManager = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    @discardableResult
    func insertToken(token: JwtToken) -> Bool {
        // Entity를 가져옴
        let entity = NSEntityDescription.entity(forEntityName: "Token", in: self.context)
        // NSManagedObject를 만들어줌
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(token.accessToken, forKey: "accessToken")
            managedObject.setValue(token.refreshToken, forKey: "refreshToken")
            managedObject.setValue(token.userId, forKey: "userId")

            do {
                try context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    @discardableResult
    func insertPerson(person: Person) -> Bool {
        // Entity를 가져옴
        let entity = NSEntityDescription.entity(forEntityName: "Writing", in: self.context)
        // NSManagedObject를 만들어줌
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(person.title, forKey: "title")
            managedObject.setValue(person.tags, forKey: "tags")
            managedObject.setValue(person.teamTags, forKey: "teamTags")
            managedObject.setValue(person.recruit, forKey: "recruit")
            managedObject.setValue(person.period, forKey: "period")
            managedObject.setValue(person.explain, forKey: "explain")
            managedObject.setValue(person.option, forKey: "option")
            managedObject.setValue(person.proceed, forKey: "proceed")
            managedObject.setValue(person.detail, forKey: "detail")
            do {
                try context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}


