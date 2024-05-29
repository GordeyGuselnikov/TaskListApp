//
//  TaskViewController.swift
//  TaskListApp
//
//  Created by Guselnikov Gordey on 29.05.24.
//

import UIKit

final class TaskViewController: UIViewController {
	
	private let storageManager = StorageManager.shared
	
	weak var delegate: TaskViewControllerDelegate?
	
	private lazy var taskTextField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.placeholder = "New Task"
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		return textField
	}()
	
	private lazy var saveButton: UIButton = {
		let filledButtonFactory = FilledButtonFactory(
			title: "Save Task",
			color: UIColor(named: "MainBlue") ?? .systemBlue,
			action: UIAction { [unowned self] _ in
				save()
			}
		)
		return filledButtonFactory.createButton()
	}()
	
	private lazy var cancelButton: UIButton = {
		let filledButtonFactory = FilledButtonFactory(
			title: "Cancel",
			color: UIColor(named: "MainRed") ?? .systemBlue,
			action: UIAction { [unowned self] _ in
				dismiss(animated: true)
			}
		)
		return filledButtonFactory.createButton()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		setupSubview(taskTextField, saveButton, cancelButton)
		setupConstraints()
	}
	
	private func setupSubview(_ subviews: UIView...) {
		subviews.forEach { subview in
			view.addSubview(subview)
		}
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
				taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
				taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
		
				saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
				saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
		
				cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
				cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
		])
	}
	
	private func save() {
		guard let task = taskTextField.text, !task.isEmpty else { return }
		
		storageManager.create(task) { [unowned self] task in
			delegate?.insertTask(task: task)
			dismiss(animated: true)
		}
	}
}
