//
//  ItemDetailViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 2/5/21.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    @IBOutlet weak var editAndSaveButton: UIBarButtonItem!
    
    var detailItem: ListItem?
    var detailItems: [String] = []
    var reloadListClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        guard let itemsFromDetailItem = detailItem?.detailItems else { return }
        detailItems = itemsFromDetailItem
        tableView.reloadData()
    }
    
    @IBAction func addButtonItemClicked(_ sender: Any) {
        promptForAnswer()
    }
    
    @IBAction func didTapEditAndSaveButton(_ sender: Any) {
        if tableView.isEditing {
            tableView.isEditing = false
            editAndSaveButton.title = "Edit"
        } else {
            tableView.isEditing = true
            editAndSaveButton.title = "Save"
        }
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text
            guard let newItem = answer else { return }
            self.detailItems.append(newItem)
            self.detailItem?.detailItems = self.detailItems
            self.detailItem?.saveItem()
            self.tableView.reloadData()
            self.reloadListClosure?()
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
}

extension ItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ItemDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = detailItems[indexPath.row]

        cell.textLabel?.text = item

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            detailItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            detailItem?.detailItems = detailItems
            detailItem?.saveItem()
            reloadListClosure?()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.detailItems[sourceIndexPath.row]
        detailItems.remove(at: sourceIndexPath.row)
        detailItems.insert(movedObject, at: destinationIndexPath.row)
        detailItem?.detailItems = detailItems
        detailItem?.saveItem()
        reloadListClosure?()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
