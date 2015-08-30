//
//  ShowViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 30/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData

class ShowViewController: UIViewController {
    
    var idToShow = Int();
    var movie = NSDictionary();
    var localMovie:AnyObject = "";
    var local = true;
    
    func makeAddButton(){
        var addButton : UIBarButtonItem = UIBarButtonItem(title: "À regarder", style: UIBarButtonItemStyle.Plain, target: self, action: "addMovie")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func makeRemoveButton(){
        var addButton : UIBarButtonItem = UIBarButtonItem(title: "Je l'ai vu !", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteMovie")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addMovie(){
        
        
        var newMovie = NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: context) as! NSManagedObject;
        
        newMovie.setValue(movie["title"] as! String, forKey: "title");
        newMovie.setValue(movie["id"] as! Int, forKey: "id");
        context.save(nil);
    }
    
    func deleteMovie(){
        
        context.deleteObject(localMovie as! NSManagedObject);
        self.performSegueWithIdentifier("backToList", sender: AnyObject?());
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if local != true{
            irina.showMovie(idToShow, completionHandler: { (data, error) -> Void in
                
                if (data != nil) {
                    self.movie = data
                    
                } else {
                    println("api.showMovie failed")
                    println(error)
                }
            })
            
            makeAddButton();
        }else{
             irina.showLocalMovie(idToShow, completionHandler: { (data, error) -> Void in
                    self.localMovie = data

            })
            makeRemoveButton();
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
