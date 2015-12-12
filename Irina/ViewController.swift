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
            let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers))as! NSDictionary
            
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
            let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers))as! NSDictionary
            
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
        let request = NSFetchRequest(entityName: "Movie");
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "id = %@", "\(id)");
        let findMovies = try! context.executeFetchRequest(request);
        
        for movie in findMovies{
            theMovie = movie;
        }
        
        let count = context.countForFetchRequest(request, error: nil);
        
        if count == 0{
            theMovie = 0;
        }
        
        return completionHandler(theMovie, nil);
    }
    
    func createList(title: String){
        
        let newList = NSEntityDescription.insertNewObjectForEntityForName("Lists", inManagedObjectContext: context) ;
        
        newList.setValue(title, forKey: "name");
        let listId = irina.createId(15);
        newList.setValue(listId as String, forKey: "id");
        
        
        
        do {
            try context.save()
        } catch _ {
        };
        
        
    }
    
    func loadLists(table: UITableView){
        let request = NSFetchRequest(entityName: "Lists")
        request.returnsObjectsAsFaults = false;
        lists = try! context.executeFetchRequest(request);
        table.reloadData();
        
    }
    
    func findList(title:String, completionHandler: ((AnyObject, NSError!) -> Void)!) -> Void {
        
        var theList : AnyObject = "";
        let request = NSFetchRequest(entityName: "Lists");
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format: "name = %@", "\(title)");
        let findList = try! context.executeFetchRequest(request);
        
        for list in findList{
            theList = list;
        }
        
        let count = context.countForFetchRequest(request, error: nil);
        
        if count == 0{
            theList = 0;
        }
        
        return completionHandler(theList, nil);
    }
    
    func createId (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
}

func addBlurEffect(view:UIViewController) {
    
    view.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    view.navigationController!.navigationBar.shadowImage = UIImage()
    view.navigationController!.navigationBar.translucent = true
}

var irina = irinaApi();
var moviesToWatch = [];
var lists = [];
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

