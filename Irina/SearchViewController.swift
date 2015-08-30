//
//  SearchViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 29/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData


class SearchViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var movieTable: UITableView!
    var movies: NSMutableArray = [];
    var selectedMovie = NSDictionary();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        irina.searchMovies("mission", completionHandler: {data, error -> Void in
            
            if (data != nil) {
                self.movies = NSMutableArray(array: data);
                dispatch_async(dispatch_get_main_queue(), { self.movieTable.reloadData() })
            } else {
                println("api.getData failed")
                println(error)
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        if let actualMovie = self.movies[indexPath.row]["title"] as? NSString {
            
            cell.textLabel?.text = actualMovie as? String
        } else {
            cell.textLabel?.text = "No Name"
        }
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovie = movies[indexPath.row] as! NSDictionary
        performSegueWithIdentifier("showMovie", sender: AnyObject?())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMovie" {
            var secondView: ShowViewController = segue.destinationViewController as! ShowViewController
            
            secondView.idToShow = (selectedMovie["id"] as? Int)!;
            secondView.title = selectedMovie["title"] as? String;
            secondView.local = false;
            
            
        }
        
    }
    
    
    
}
