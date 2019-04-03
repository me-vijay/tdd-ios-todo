//
//  ItemListViewController.swift
//  TDD_iOS_ToDo
//
//  Created by venD-vijay on 25/01/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDetails(sender:)),
            name: NSNotification.Name("ItemSelectedNotification"),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextVC.itemManager = itemManager
            present(nextVC, animated: true) {
                
            }
        }
    }
    
    @objc func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int  else { fatalError() }
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            nextVC.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
