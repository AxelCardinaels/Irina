//
//  ListViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 30/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var movieToWatchTable: UITableView!
    var selectedId = Int()
    var movieToDelete:AnyObject = "";
    var refresher : UIRefreshControl = UIRefreshControl()
    
    func refreshData(){
        
        loadList()
        movieToWatchTable.reloadData()
        self.refresher.endRefreshing()
    }
    
    func loadList(){
        var request = NSFetchRequest(entityName: "Movie")
        request.returnsObjectsAsFaults = false;
        moviesToWatch = context.executeFetchRequest(request,error:nil)!;
        movieToWatchTable.reloadData();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect(self);
        movieToWatchTable.rowHeight = UITableViewAutomaticDimension
        movieToWatchTable.estimatedRowHeight = 77.0;
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Mise en place du refresh
        refresher.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        movieToWatchTable.addSubview(refresher)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        
        if let actualMovie = moviesToWatch[indexPath.row].valueForKey("title") as? NSString {
            
            cell.movieTitle?.text = actualMovie as? String
            
            if let movieDate = moviesToWatch[indexPath.row].valueForKey("releaseYear") as? NSString{
                cell.movieTitle?.text = "\(actualMovie as! String) (\(movieDate as! String))"
            }
        } else {
            cell.movieTitle?.text = "No Name"
        }
        
        
        cell.movieTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.movieTitle.numberOfLines = 0;

        
        
        if let type1 = moviesToWatch[indexPath.row].valueForKey("type1") as? NSString{
            if let type2 = moviesToWatch[indexPath.row].valueForKey("type2") as? NSString{
                cell.movieType.text = "\(type1) & \(type2)";
            }else{
                cell.movieType.text = type1 as String;
            }
        }
        
        if let rating = moviesToWatch[indexPath.row].valueForKey("ratingShort") as? NSString{
            cell.movieRate.text = "\(rating as String)/10";
        }
        
        
        
        
        cell.backgroundColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 0.0);
        
        
        
        return cell
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedId = moviesToWatch[indexPath.row].valueForKey("id") as! Int
        performSegueWithIdentifier("showMovie", sender: AnyObject?())
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        selectedId = moviesToWatch[indexPath.row].valueForKey("id") as! Int;
        if editingStyle == UITableViewCellEditingStyle.Delete {
            irina.showLocalMovie(selectedId, completionHandler: { (data, error) -> Void in
                self.movieToDelete = data
                context.deleteObject(self.movieToDelete as! NSManagedObject);
                context.save(nil);
                self.loadList();
                self.movieToWatchTable.reloadData()
            })
            
        }
        
      
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMovie" {
            var secondView: ShowViewController = segue.destinationViewController as! ShowViewController
            

            secondView.idToShow = selectedId
            secondView.local = true;
            
            
        }
        
    }
    
    
    
}
