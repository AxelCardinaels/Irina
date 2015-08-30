//
//  ListViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 30/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    
    @IBOutlet var movieToWatchTable: UITableView!
    var selectedMovie = [String : AnyObject]()
    
    func loadList(){
        var request = NSFetchRequest(entityName: "Movie")
        request.returnsObjectsAsFaults = false;
        moviesToWatch = context.executeFetchRequest(request,error:nil)!;
        movieToWatchTable.reloadData();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadList();
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return moviesToWatch.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        if let actualMovie = moviesToWatch[indexPath.row].valueForKey("title") as? NSString {
            
            cell.textLabel?.text = actualMovie as? String
        } else {
            cell.textLabel?.text = "No Name"
        }
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovie = [
            "title" : moviesToWatch[indexPath.row].valueForKey("title") as! String,
            "id" : moviesToWatch[indexPath.row].valueForKey("id") as! Int
        ];
        performSegueWithIdentifier("showMovie", sender: AnyObject?())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMovie" {
            var secondView: ShowViewController = segue.destinationViewController as! ShowViewController
            
            secondView.title = selectedMovie["title"]! as? String;
            secondView.idToShow = (selectedMovie["id"]! as? Int)!;
            secondView.local = true;
            
            
        }
        
    }
    
    
    
}
