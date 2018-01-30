//
//  CurrencyBalanceViewController.swift
//  PST
//
//  Created by Arafath on 07/06/17.
//
//

import UIKit
import SVProgressHUD

class CurrencyBalanceViewController: UIViewController,SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    //var balanceArray:NSMutableArray = []

    
    var balanceArray:JSON = []

    var branchArray:NSMutableArray = []
    var leftArray:NSArray = []
    var branchId:String = ""
    var branchName:String = ""
    var prevIndexpath: IndexPath = []


    @IBOutlet var branchButton:UIButton!
    @IBOutlet var transView:UIView!
    @IBOutlet var detailsView:UIView!
    @IBOutlet var detailPopupView:UIView!
    @IBOutlet var branchTable:UITableView!
    @IBOutlet var branchView:UIView!
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var tableView: UITableView!

    
    @IBOutlet var currencyImageView: UIImageView!
    @IBOutlet var currencyDescLabel: UILabel!
    @IBOutlet var currencyIdLabel: UILabel!
    @IBOutlet var currencyCostLabel: UILabel!
    @IBOutlet var currencyBalanceLabel: UILabel!
    @IBOutlet var currencyRMCostLabel: UILabel!




    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        leftArray = ["Currency", "Description", "Curr Balance"]
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        revealViewController().delegate = self
        
        // Once time - See documented SWRevealViewController.h
        revealViewController().tapGestureRecognizer()
        revealViewController().panGestureRecognizer()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
        self .callBranchApi()
        
     
        branchTable.tableFooterView = UIView()
        
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
    
    
    
    func callBranchApi()
    {
        
        SVProgressHUD.show()
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        
        

        
        let AuthKey:String =  (UserDefaults.standard.object(forKey: "AuthKey") as! String)
        let url = NSString(format:"GetBranches/%@",AuthKey)
        
        
        
        
        
        UserDefaults.standard.set(url, forKey:"url")
        
        
        
        
        
        RestApiManager.sharedInstance.getRandomUser
            {
                json in
                let results = json["GetBranchesResult"]
                
                
                SVProgressHUD .dismiss()
                
                
                if(results.count != 0)
                {
                    
                    
                    
                    
                    for (index, subJson: JSON) in results
                    {
                        
                        let BranchID: String = JSON["BranchID"].stringValue
                        let BranchName: String = JSON["BranchName"].stringValue
                        
                        
                        if(index == "0"){
                            self.branchId = JSON["BranchID"].stringValue
                            self.branchButton.setTitle(BranchName,for: .normal)
                        }
                        
                        
                        let array = [BranchID,BranchName]
                        self.branchArray .add(array)
                        
                        
                        
                        
                    }
                    
                    self .callApi()
                    
                    
                    
                }
            
        }
    }
    
    
    

    
    
    
    
    
    
    
    func callApi()
    {
        
        SVProgressHUD.show()
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: date)
        
        let AuthKey:String =  (UserDefaults.standard.object(forKey: "AuthKey") as! String)
        let url = NSString(format:"GetCurrencyBalance/%@/%@/%@",AuthKey,branchId,todayDate)
        
        
        
        
        
        UserDefaults.standard.set(url, forKey:"url")
        
        
        
        
        
        RestApiManager.sharedInstance.getRandomUser
            {
                json in
                let results = json["GetCurrencyBalanceResult"]
                
                
                SVProgressHUD .dismiss()
                
                
                if(results.count != 0)
                {
                    self.balanceArray = results as JSON
                    self.branchButton.isHidden = false
                    self.tableView .reloadData()
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Alert!", message: "No Records Found", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
        }
    }
    
  
    
    
    
    
    
    
    
    
    
    //
    // MARK: - TableView Controller DataSource and Delegate
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       return 1
        
        
//        if tableView == branchTable {
//            return 1
//        }
//        
//        return balanceArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == branchTable {
        return branchArray.count
        }
        
        return balanceArray.count
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == branchTable {
            return 40
        }
        
        return 60
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell?)!
        
        
        
        if tableView == branchTable {
           let array:NSArray = branchArray[indexPath.row] as! NSArray
           cell.nameLabel.text = array[1] as? String
            cell.accessoryType = .none
        }
        else
        {


            
            cell.roundRectView.layer.cornerRadius = 8.0
            cell.roundRectView.layer.borderColor = UIColor.gray.cgColor
            cell.roundRectView.layer.borderWidth = 0.5
            cell.roundRectView.clipsToBounds = true
            
            
            // shadow
            cell.roundRectView.layer.shadowColor = UIColor.black.cgColor
            cell.roundRectView.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.roundRectView.layer.shadowOpacity = 0.7
            cell.roundRectView.layer.shadowRadius = 4.0
            
            
            cell.currencyLabel.text = balanceArray[indexPath.row]["CURR_ID"].string
            cell.balanceLabel.text = balanceArray[indexPath.row]["CURR_BALANCE"].string

            
            let SHOW_COST_RATE = balanceArray[indexPath.row]["SHOW_COST_RATE"].string
            if SHOW_COST_RATE == "1" {
                cell.costLabel.text = balanceArray[indexPath.row]["CURR_COST"].string
            }
            
            

          
            if let urlString = balanceArray[indexPath.row]["CURR_FLAG_URL"].string{
                
                if urlString != "" {
                    ImageLoader.sharedLoader.imageForUrl(urlString: urlString, completionHandler:{(image: UIImage?, url: String) in
                        cell.currencyimageView.image = image
                    })
                }
                else{

                }
                
          
            }
            
        }
        
        return cell
    }

    
       
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
      

        
        
        if tableView == branchTable {
            
            
            let array:NSArray = branchArray[indexPath.row] as! NSArray
            branchId = array[0] as! String
            branchName = array[1] as! String
            
            if prevIndexpath != []{
                let cell = tableView.cellForRow(at: prevIndexpath)
                cell?.accessoryType = .none

            }
        
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            prevIndexpath = indexPath
            
            self.branchButton.setTitle(branchName,for: .normal)

            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut,
                           animations: {self.transView.alpha = 0},
                           completion: { _ in   self.transView.removeFromSuperview()
                            //Do anything else that depends on this animation ending
            })
            
            
            
            self .callApi()
            
        }
        else
        {
            let SHOW_COST_RATE = balanceArray[indexPath.row]["SHOW_COST_RATE"].string
            if SHOW_COST_RATE == "1" {
                
                
                if let urlString = balanceArray[indexPath.row]["CURR_FLAG_URL"].string{
                    
                    if urlString != "" {
                        ImageLoader.sharedLoader.imageForUrl(urlString: urlString, completionHandler:{(image: UIImage?, url: String) in
                            self.currencyImageView.image = image
                        })
                    }
                   }
                
                currencyDescLabel.text = balanceArray[indexPath.row]["CURR_DESCR"].string
                currencyIdLabel.text = balanceArray[indexPath.row]["CURR_ID"].string
                currencyCostLabel.text = balanceArray[indexPath.row]["CURR_COST"].string
                currencyBalanceLabel.text = balanceArray[indexPath.row]["CURR_BALANCE"].string
                currencyRMCostLabel.text = balanceArray[indexPath.row]["CURR_RM_BALANCE"].string


                
                
                
                detailsView.alpha = 1.0
                detailsView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                detailsView.frame = UIScreen.main.bounds
                self.view.addSubview(detailsView)
                
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
                gestureRecognizer.delegate = self
                detailsView.addGestureRecognizer(gestureRecognizer)
                
                
                
                self.detailPopupView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                UIView.animate(withDuration: 0.3 / 1.5, animations: {    self.detailPopupView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                    
                }, completion: {(finished: Bool) in    UIView.animate(withDuration: 0.3 / 2, animations: {   self.detailPopupView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                    
                }, completion: {(finished: Bool) in  UIView.animate(withDuration: 0.3 / 2, animations: {            self.detailPopupView.transform = CGAffineTransform.identity
                    
                })
                    
                })
                    
                })
                

            }
            
            
            
            
        }
        
        
    
    }
    

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
       
        if (touch.view!.isDescendant(of: branchView)) || (touch.view!.isDescendant(of: detailPopupView)){
            return false
        }
        return true
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut,
                       animations: {self.transView.alpha = 0},
                       completion: { _ in   self.transView.removeFromSuperview()
        })
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut,
                       animations: {self.detailsView.alpha = 0},
                       completion: { _ in   self.detailsView.removeFromSuperview()
        })
        
}
    
    
    
 //   MARK: - Branch Button Click Action
    
    
    
    @IBAction func branchButtonClicked()
    {
        transView.alpha = 1.0
        transView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        transView.frame = UIScreen.main.bounds
        self.view.addSubview(transView)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        transView.addGestureRecognizer(gestureRecognizer)


        
        self.branchView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3 / 1.5, animations: {    self.branchView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            
        }, completion: {(finished: Bool) in    UIView.animate(withDuration: 0.3 / 2, animations: {   self.branchView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            
        }, completion: {(finished: Bool) in  UIView.animate(withDuration: 0.3 / 2, animations: {            self.branchView.transform = CGAffineTransform.identity
            
        })
            
        })
            
        })
        

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
