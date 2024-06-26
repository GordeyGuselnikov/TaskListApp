//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Guselnikov Gordey on 29.05.24.
//

import CoreData

final class StorageManager {
	
	static let shared = StorageManager()
	
	// MARK: - Core Data stack
	private let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "TaskListApp")
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	private let viewContext: NSManagedObjectContext
	
	private init() {
		viewContext = persistentContainer.viewContext
	}
	
	// MARK: - CRUD
	
	func create(_ taskName: String, completion: (Task) -> Void) {
		let task = Task(context: viewContext)
		task.title = taskName
		completion(task)
		saveContext()
	}
	
	func fetchData(completion: (Result<[Task], Error>) -> Void) {
		let fetchRequest = Task.fetchRequest()
		
		do {
			let tasks = try viewContext.fetch(fetchRequest)
			completion(.success(tasks))
		} catch {
			completion(.failure(error))
		}
	}
	
	func update(_ task: Task, newName: String) {
		task.title = newName
		saveContext()
	}
	
	func delete(_ task: Task) {
		viewContext.delete(task)
		saveContext()
	}
	
	// MARK: - Core Data Saving support
	func saveContext() {
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
