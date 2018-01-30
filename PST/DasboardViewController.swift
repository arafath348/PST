//
//  DasboardViewController.swift
//  PST
//
//  Created by Arafath on 28/05/17.
//
//

import UIKit

class DasboardViewController: UIViewController, SWRevealViewControllerDelegate {
    @IBOutlet var menuButton:UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        revealViewController().delegate = self
        
        // Once time - See documented SWRevealViewController.h
        revealViewController().tapGestureRecognizer()
        revealViewController().panGestureRecognizer()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
        
        
    }
    
    
    

    
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if position == FrontViewPosition.right {
            
            
            let lock = UIView(frame: self.view.bounds)
            lock.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            lock.tag = 100
            lock.alpha = 0
            lock.backgroundColor = UIColor.black
            lock.addGestureRecognizer(UITapGestureRecognizer(target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            self.view.addSubview(lock)
            UIView.animate(withDuration: 0.5, animations: {
                lock.alpha = 0.3
            }
            )
            
        }
        else {
            let viewWithTag = self.view.viewWithTag(100)
            viewWithTag?.removeFromSuperview()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
