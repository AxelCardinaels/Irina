//
//  ViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 29/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData


class irinaApi {
    func searchMovies(search:String, completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        var escapedSearch = search.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url: NSURL = NSURL(string: "https://api.betaseries.com/movies/search?title=\(escapedSearch!)&key=14cbb71a3f03")!
        
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
                
            }
            
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
            
            if (error != nil) {
                return completionHandler(nil, error)
                
            } else {
                return completionHandler(json["movies"] as! [NSDictionary], nil);
            }
        })
        task.resume()
    }
    
    func showMovie(id:Int, completionHandler: ((NSDictionary!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: "https://api.betaseries.com/movies/movie?id=\(id)&key=14cbb71a3f03")!
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
            
            if (error != nil) {
                return completionHandler(nil, error)
            } else {
                return completionHandler(json["movie"] as! NSDictionary, nil);
            }
        })
        task.resume()
    }
    
    func showLocalMovie(id:Int, completionHandler: ((AnyObject, NSError!) -> Void)!) -> Void {
        
        var theMovie : AnyObject = "";
        var request = NSFetchRequest(entityName: "Movie");
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "id = %@", "\(id)");
        var findMovies = context.executeFetchRequest(request, error: nil)!;
        
        for movie in findMovies{
            theMovie = movie;
        }
        
        return completionHandler(theMovie, nil);
    }
    
}

var irina = irinaApi();
var moviesToWatch = [];
var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
var context:NSManagedObjectContext = appDel.managedObjectContext!

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
}

