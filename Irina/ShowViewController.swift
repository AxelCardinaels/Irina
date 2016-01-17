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
    
    @IBOutlet var scrollViewContrainer: UIView!
    @IBOutlet var scrollViewConstraints: NSLayoutConstraint!
    
    @IBOutlet var movieCover: UIImageView!
    @IBOutlet var titleView: UIView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieType: UILabel!
    @IBOutlet var resumeView: UIView!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieResume: UILabel!
    @IBOutlet var infoView: UIView!
    @IBOutlet var movieReal: UILabel!
    @IBOutlet var movieLenght: UILabel!
    @IBOutlet var movieRate: UILabel!
    
    
    
    
    
    
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
        
        //var documentsDirectory:String?
        //var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        //if paths.count > 0 {
        //  documentsDirectory = paths[0] as? String
        //var savePath = documentsDirectory! + "\(movie["id"] as! String).jpg"
        //NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
        //}
        
        
        
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
    
    func setLocalMovie(){
        
        movieTitle.text = "Spectre (2015)";
        movieType.text = "Action & espionnage";
        movieResume.text = "Un message cryptique venu tout droit de son passé pousse Bond à enquêter sur une sinistre organisation. Alors que M affronte une tempête politique pour que les services secrets puissent continuer à opérer, Bond s'échine à révéler la terrible vérité derrière... le Spectre."
        movieReal.text = "Sam Mendez";
        movieLenght.text = "150 minutes";
        movieRate.text = "7/10";
        
        dispatch_async(dispatch_get_main_queue(), {
            self.setScrollHeight()
        })
        
    }
    
    func setOnlineMovie(){
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let fullDate: String = self.movie["release_date"] as! String
            var fullDateParts = fullDate.componentsSeparatedByString("-")
            
            if fullDateParts[0] == ""{
                self.movieTitle.text = self.movie["title"] as? String
            }else{
                self.movieTitle.text = "\((self.movie["title"] as? String)!) (\(fullDateParts[0]))"
            }
            
            let genres = self.movie["genres"] as! NSArray
            if genres.count == 0{
                self.movieType.text = "Pas de genre";
            }
            
            if genres.count == 1 {
                self.movieType.text = genres[0] as? String;
            }
            
            if genres.count > 1{
                self.movieType.text = "\(genres[0] as! String) & \(genres[1] as! String) ";
            }
            
            let resume = self.movie["synopsis"] as? String;
            
            if resume == ""{
                self.movieResume.text = "Désolé, mais nous n'avons malheureusement pas trouver de résumé pour ce film !";
            }else{
                self.movieResume.text = resume
            }
            
            let real = self.movie["director"] as! String;
            
            if real == ""{
                self.movieReal.text = "Non renseigné";
            }else{
                self.movieReal.text = real;
            }
            
            
            let notes = self.movie["notes"] as! NSDictionary;
            let note = notes["mean"] as! NSString;
            let noteMiddle = note
            let noteFull = ((noteMiddle as NSString).floatValue)*2
            let noteShort = (NSString(format: "%.01f", noteFull))
            self.movieRate.text = "\(noteShort)/10";
            
            let length = self.movie["length"] as? NSString;
            let lengthNumber = length!.intValue
            self.movieLenght.text = "\(lengthNumber/60) minutes";
            
            self.setScrollHeight()
        })
        
        
    }
    
    func setScrollHeight(){
        
        let height1 = movieCover.frame.height
        let height2 = titleView.frame.height
        let height3 = resumeView.frame.height
        let height4 = infoView.frame.height
        let scrollHeight = height1 + height2 + height3 + height4
        scrollViewConstraints.constant = scrollHeight + 120;
    }
    
    func makeBackground(){
        let backgroundImage = UIImage(named : "BackgroundDetail");
        let backgroundImageView:UIImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.alpha = 0.15;
        self.view.insertSubview(backgroundImageView, atIndex: 0);
        
        moviePoster.layer.shadowColor = UIColor.blackColor().CGColor
        moviePoster.layer.shadowOpacity = 1
        moviePoster.layer.shadowOffset = CGSize(width: 2, height: 2)
        moviePoster.layer.shadowRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        if local != true{
            irina.showMovie(idToShow, completionHandler: { (data, error) -> Void in
                
                if (data != nil) {
                    self.movie = data
                    self.setOnlineMovie()
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
                    self.setLocalMovie();
                    self.makeRemoveButton()
                    
                }
                
            })
            
            
        }else{
            irina.showLocalMovie(idToShow, completionHandler: { (data, error) -> Void in
                self.localMovie = data
                self.setLocalMovie();
            })
            makeRemoveButton();
        }
        
        makeBackground();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
