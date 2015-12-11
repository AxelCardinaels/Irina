//
//  ListsViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 9/12/15.
//  Copyright © 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData

class ListsViewController: UIViewController {
    
    @IBOutlet var ListsTableView: UITableView!
    var listToDelete:AnyObject = "";
    
    func makeAddButton(){
        let addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addList")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addList(){
        //1. Création de l'alerte
        
            let alert = UIAlertController(title: nil, message: "Créer une liste", preferredStyle: UIAlertControllerStyle.Alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Nom de la liste"
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                
                if textField.text != ""{
                    irina.createList(textField.text!);
                    irina.loadLists(self.ListsTableView);
                    
                }else{
                    irina.createList("Liste sans titre");
                    irina.loadLists(self.ListsTableView);
                }
                
                
            }))
        
            
            alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            // 4. Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        irina.loadLists(ListsTableView);
        
        ListsTableView.rowHeight = UITableViewAutomaticDimension
        ListsTableView.estimatedRowHeight = 77.0;
        self.navigationItem.setHidesBackButton(true, animated: true)
        makeAddButton()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return lists.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListsCell", forIndexPath: indexPath) as! ListsTableViewCell
        
        
        if let actualList = lists[indexPath.row].valueForKey("name") as? NSString {
            
            cell.ListTitle.text = actualList as String
            
        };
        
        
        cell.ListItems.text = "3 films";
        
        cell.ListTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.ListTitle.numberOfLines = 0;
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 5/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0);
        cell.selectedBackgroundView = bgColorView;
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        let selectedList = lists[indexPath.row].valueForKey("name") as! String;
        print(selectedList)
        if editingStyle == UITableViewCellEditingStyle.Delete {
            irina.findList(selectedList, completionHandler: { (data, error) -> Void in
                self.listToDelete = data
                
                print(self.listToDelete)
                context.deleteObject(self.listToDelete as! NSManagedObject);
                do {
                    try context.save()
                } catch _ {
                };
                irina.loadLists(self.ListsTableView);
            })
            
        }
        
        
    }
    
    
}


