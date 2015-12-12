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
        let addButton : UIBarButtonItem = UIBarButtonItem(title: "À regarder", style: UIBarButtonItemStyle.Plain, target: self, action: "addMovie")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func makeRemoveButton(){
        let addButton : UIBarButtonItem = UIBarButtonItem(title: "Je l'ai vu !", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteMovie")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addMovie(){
        
        let newMovie = NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: context) ;
        
        let genres = movie["genres"] as! NSArray
        
        var genre1 = "";
        var genre2 = "";
        
        
        if genres.count == 0{
            genre1 = "Pas de genres";
            genre2 = "";
        }
        
        
        if genres.count == 1 {
            genre1 = genres[0] as! String;
            genre2 = "";
        }
        
        if genres.count > 1{
            genre1 = genres[0] as! String;
            genre2 = genres[1] as! String;
        }
        
        
        
        
        let notes = movie["notes"] as! NSDictionary;
        let note = notes["mean"] as! NSString;
        let noteMiddle = note
        let noteFull = ((noteMiddle as NSString).floatValue)*2
        
        let noteShort = (NSString(format: "%.01f", noteFull))
        
        
        let fullDate: String = movie["release_date"] as! String
        var fullDateParts = fullDate.componentsSeparatedByString("-")
        
        
        newMovie.setValue(movie["title"] as! String, forKey: "title");
        newMovie.setValue(movie["id"] as! Int, forKey: "id");
        
        if genre1 != "" {
            newMovie.setValue(genre1, forKey: "type1");
            
            if genre2 != ""{
                newMovie.setValue(genre2, forKey: "type2");
            }
        }
        
        
        newMovie.setValue(fullDateParts[0], forKey: "releaseYear");
        newMovie.setValue(fullDateParts[1], forKey: "releaseMonth");
        newMovie.setValue(fullDateParts[2], forKey: "releaseDay");
        newMovie.setValue("\(note)", forKey: "ratingFull");
        newMovie.setValue("\(noteShort)", forKey: "ratingShort");
        newMovie.setValue("ayDOhpbr6egsxoo", forKey: "listId");
        
        
        
        do {
            try context.save()
        } catch _ {
        };
    }
    
    func deleteMovie(){
        
        context.deleteObject(localMovie as! NSManagedObject);
        do {
            try context.save()
        } catch _ {
        };
        
        
        
        self.performSegueWithIdentifier("backToList", sender: AnyObject?());
        
    }
    
    func setMovie(){
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        if local != true{
            irina.showMovie(idToShow, completionHandler: { (data, error) -> Void in
                
                if (data != nil) {
                    self.movie = data
                    
                    
                } else {
                    print("api.showMovie failed")
                    print(error)
                }
            })
            
            irina.showLocalMovie(idToShow, completionHandler: { (data, error) -> Void in
                
                
                
                if data as! NSObject == 0 {
                    
                    self.makeAddButton()
                } else {
                     self.localMovie = data
                    self.makeRemoveButton()
                   
                }
                
            })
            
            
            
            
            
        }else{
            irina.showLocalMovie(idToShow, completionHandler: { (data, error) -> Void in
                self.localMovie = data
                
                
                self.setMovie();
                
                
            })
            makeRemoveButton();
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
