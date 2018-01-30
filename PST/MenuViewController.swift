//
//  MenuViewController.swift
//  PST
//
//  Created by Arafath on 28/05/17.
//
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuArray:NSArray = []
    var alreadyClicked : Bool = false
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        alreadyClicked = false
//        textArray = NSMutableArray()
        //        textArray  = ["Dashboard", "Transaction Authorization","Currency Balance","Logout"]

        
        
        menuArray =  UserDefaults.standard.array(forKey: "menuArray")! as NSArray
        
        print(menuArray)
        
        
        
        if let Username:String =  UserDefaults.standard.object(forKey: "Username") as? String{
            
            let nameString = NSString(format:"Welcome %@",Username)
            nameButton.setTitle(nameString as String, for: .normal)
            
        }
        
        
        table .reloadData()
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
        
        
        
    }
    
    
    // MARK: - Table view data source
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell?)!
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        cell.nameLabel.text = menuArray .object(at: indexPath.row) as? String
        
        return cell
    }
    
    
    
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
        
        
        if alreadyClicked == false {
            alreadyClicked = true
            var controller: UIViewController?
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            switch (menuArray .object(at: indexPath.row) as! String) {
            case "Dashboard":
                controller = storyboard.instantiateViewController(withIdentifier: "DasboardViewController") as? DasboardViewController
                let navController = UINavigationController(rootViewController: controller!)
                revealViewController().pushFrontViewController(navController, animated:true)
                
                
            case "Trans. Authorization":
                controller = storyboard.instantiateViewController(withIdentifier: "TransAuthorViewController") as? TransAuthorViewController
                let navController = UINavigationController(rootViewController: controller!)
                revealViewController().pushFrontViewController(navController, animated:true)
                
                
                
            case "Currency Balance":
                controller = storyboard.instantiateViewController(withIdentifier: "CurrencyBalanceViewController") as? CurrencyBalanceViewController
                let navController = UINavigationController(rootViewController: controller!)
                revealViewController().pushFrontViewController(navController, animated:true)
                
              
            case "Logout":
                
                // Create the alert controller
                let alertController = UIAlertController(title: "Logout", message: "Are you sure do you want to Logout?", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in

                    
                    
                    
                    controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let navController = UINavigationController(rootViewController: controller!)
                    self.view.window?.rootViewController = navController
                    self.navigationController?.pushViewController(navController, animated: true)
                    
                    
                    
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    self.alreadyClicked = false
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            
                
        
                
                
            default: break
            }
            
            
            
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
