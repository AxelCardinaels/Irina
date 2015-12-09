//
//  ListsViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 9/12/15.
//  Copyright © 2015 Axel Cardinaels. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController {
    
    @IBOutlet var ListsTableView: UITableView!
    var userLists = ["Test","Test"];
    
    func makeAddButton(){
        let addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addList")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addList(){
        //1. Création de l'alerte
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: nil, message: "Créer une liste", preferredStyle: UIAlertControllerStyle.Alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Nom de la liste"
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                print("Text field: \(textField.text)")
            }))
            
            alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            // 4. Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListsTableView.rowHeight = UITableViewAutomaticDimension
        ListsTableView.estimatedRowHeight = 77.0;
        self.navigationItem.setHidesBackButton(false, animated: true)
        makeAddButton()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return userLists.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListsCell", forIndexPath: indexPath) as! ListsTableViewCell
        
        
        
        cell.ListTitle.text = "du texte du texte du texte du texte du texte encore du texte";
        cell.ListItems.text = "3 films";
        
        cell.ListTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.ListTitle.numberOfLines = 0;
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 5/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0);
        cell.selectedBackgroundView = bgColorView;
        
        
        
        return cell
    }
    
    
    
    
}


