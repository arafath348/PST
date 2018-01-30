//
//  TransAuthorViewController.swift
//  PST
//
//  Created by Arafath on 28/05/17.
//
//

import UIKit
import SVProgressHUD


struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    

    
    init(name: String, items: [String], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}





class TransAuthorViewController: UIViewController, SWRevealViewControllerDelegate, CollapsibleTableViewHeaderDelegate,UITableViewDelegate,UITableViewDataSource
    
{
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var transView:UIView!
    @IBOutlet var reasonTable:UITableView!
    @IBOutlet var reasonView:UIView!


    var receiptArray:NSMutableArray = []
    var transDetailsArray:NSMutableArray = []
    var reasonAddedArray:NSMutableArray = []
    var reasonArray:NSMutableArray = []
    var reasonTableArray:NSArray = []
    var receiptNumber:NSString = ""
    var sectionNumber:NSInteger = -1

    
    var leftArray:NSArray = []
    var sections = [Section]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reasonTable.estimatedRowHeight = 44

        
        
        leftArray = ["Receipt Amount", "Counter", "User Id", "Purpose", "Source", "Branch", "Processed On"]
        
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        // Once time - See documented SWRevealViewController.h
        revealViewController().tapGestureRecognizer()
        revealViewController().panGestureRecognizer()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
        self .callApi()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        revealViewController().delegate = self
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
    
    
    
    
    
    func callApi()
    {
        
        SVProgressHUD.show()
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        
         let AuthKey:String =  (UserDefaults.standard.object(forKey: "AuthKey") as! String)
         let url = NSString(format:"GetPendingTransDetails/%@",AuthKey)
        
        
        
        
        
        UserDefaults.standard.set(url, forKey:"url")
        
        
    
        
        
        RestApiManager.sharedInstance.getRandomUser
            {
                json in
                let results = json["GetPendingTransDetailsResult"]
                
                
                
                SVProgressHUD .dismiss()
                
                
                if(results.count != 0)
                {
                    
                    
                     self.sections = [Section]()

                    for (_, subJson: JSON) in results
                    {
                        let name: String = JSON["TXN_CUST_NAME"].string!
                        let amnt: String = JSON["RECEIPT_AMT"].string!
                        let counter: String = JSON["SUBCOUNTERNAME"].string!
                        let userId: String = JSON["TXN_USER_ID"].string!
                        let purpose: String = JSON["PURPOSEOFTRANS"].string!
                        let source: String = JSON["SOURCEOFFUND"].string!
                        let branch: String = JSON["BRANCHNAME"].string!
                        let date: String = JSON["ENTERED_DATE"].string!
                     
                        
                        
                        let sec = Section(name: name, items:[amnt,counter,userId,purpose,source,branch,date])
                        self.sections .append(sec)
                        
                        

                        
                    
                        let reciept: String = JSON["TXN_REC_NUMBER"].string!
                        self.receiptArray .add(reciept)
                        
                        
   
                        
                      let TransDetailsCols = JSON["TransDetailsCols"]
                        

                        
                     
                        var mutableArray:NSMutableArray = []

                        
                        
                        for (index: i, subJson: _) in TransDetailsCols
                    {
                        
                        let currId: String = TransDetailsCols[Int(i)!]["TXN_CURR_ID"].string!
                        let type: String = TransDetailsCols[Int(i)!]["TXN_TYPE"].string!
                        let txn_amount: String = TransDetailsCols[Int(i)!]["TXN_AMT"].string!
                        let exchange: String = TransDetailsCols[Int(i)!]["TXN_EXCHG_RATE"].string!
                        let rm_amount: String = TransDetailsCols[Int(i)!]["TXN_RM_AMT"].string!
                        
                        let trans = [currId,type,txn_amount,exchange,rm_amount]
                        mutableArray .add(trans)

                        }

                        
                        self.transDetailsArray .add(mutableArray)

                        
        
                        
                        
                        
                        
                        
                        mutableArray = []
                        let TransReasonCols = JSON["TransReasonCols"]

                        print(TransReasonCols)

                        
                        for (index: i, subJson: _) in TransReasonCols
                        {
                            
                            
                            let STATUS_MESSAGE: String = TransReasonCols[Int(i)!]["STATUS_MESSAGE"].string!
                            
                            let TRANS_AUTH_ID: String = TransReasonCols[Int(i)!]["TRANS_AUTH_ID"].string!
                            let TRANS_AUTH_INFO_ID: String = TransReasonCols[Int(i)!]["TRANS_AUTH_INFO_ID"].string!
                            let CONFIG_ID: String = TransReasonCols[Int(i)!]["CONFIG_ID"].string!
                            let AUTH_GROUP_ID: String = TransReasonCols[Int(i)!]["AUTH_GROUP_ID"].string!



                            let status = [STATUS_MESSAGE,TRANS_AUTH_ID,TRANS_AUTH_INFO_ID,CONFIG_ID,AUTH_GROUP_ID]
                            mutableArray .add(status)
                        }
                        
                        
                        self.reasonArray .add(mutableArray)
                        
                    
                        
                        
                    
                    }
                    
                    
                    
                    
                    
                    self.tableView .reloadData()
                    
                    
                }
                else
                {
                    //                        let errorMessage: String = results[0]["errorStatus"].string!
                    
                    let alert = UIAlertController(title: "Alert!", message: "No Records Found", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //
    // MARK: - View Controller DataSource and Delegate
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == reasonTable {
            return 1
        }
        
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == reasonTable {
            return reasonTableArray.count
        }
        
        return sections[section].items.count+1
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        

        var cell : CustomTableViewCell

        if tableView == reasonTable {
            
            cell = (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell?)!
     
            
      let array:NSArray = reasonTableArray[indexPath.row] as! NSArray
            cell.nameLabel.text = array[0] as? String
            cell.accessoryType = .none

            cell.tintColor = UIColor(red: 0/255.0, green:127/255.0, blue: 14/255.0, alpha: 1.0)

        }
        
    
       else if(indexPath.row == leftArray.count)
        {
            cell = (tableView.dequeueReusableCell(withIdentifier: "CustomCellButton") as! CustomTableViewCell?)!
            cell.transButton.layer.cornerRadius = 8
            cell.transButton.layer.masksToBounds = true
            cell.transButton.tag = indexPath.section
            cell.transButton.titleLabel!.textAlignment = .center

            
            cell.authorButton.layer.cornerRadius = 8
            cell.authorButton.layer.masksToBounds = true
            cell.authorButton.tag = indexPath.section
            cell.authorButton.titleLabel!.textAlignment = .center

            
            cell.cancelButton.layer.cornerRadius = 8
            cell.cancelButton.layer.masksToBounds = true
            cell.cancelButton.tag = indexPath.section
            cell.cancelButton.titleLabel!.textAlignment = .center
            
        }
        else{
        
        cell = (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell?)!
        cell.leftLabel.text = leftArray[indexPath.row] as? String
        cell.rightLabel.text = sections[indexPath.section].items[indexPath.row]
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == reasonTable {
           return UITableViewAutomaticDimension
        }
        else if(indexPath.row == leftArray.count && !sections[indexPath.section].collapsed!)
        {
            return 59
        }
        return sections[indexPath.section].collapsed! ? 0 : 44.0
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView != reasonTable {

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        
        
        header.titleLabel.font = UIFont (name: "HelveticaNeue-Bold", size: 14)
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == reasonTable {
        return 0.1
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
       
        
        
        
        if tableView == reasonTable {

        
       let cell = tableView.cellForRow(at: indexPath)

    
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            self.reasonAddedArray .remove(reasonTableArray[indexPath.row])

        } else {
            cell?.accessoryType = .checkmark
            self.reasonAddedArray .add(reasonTableArray[indexPath.row])

        }
       

            
            
            print(reasonAddedArray)
            
        }
        
    }

    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        
        
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    
    
    
    
    // MARK: - Transaction Details Button Click Action

    
    
    @IBAction func transButtonClicked(_ sender: AnyObject)
    {
        let button = sender as! UIButton
        let index = button.tag
        
        
//        self.title = ""
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TransDetailsViewController") as! TransDetailsViewController
        

        controller.transDetailsArray = transDetailsArray .object(at: index) as! NSArray
    
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        
        
    }

    
    // MARK: - Authorize Transaction Button Click Action
    
    
    
    @IBAction func authorButtonClicked(_ sender: AnyObject)
    {
        let button = sender as! UIButton
        let index = button.tag
        
        
        sectionNumber = index
        
        
        
        receiptNumber = receiptArray[index] as! NSString

        reasonAddedArray = []
        reasonTableArray = reasonArray[index] as! NSArray
        reasonTable .reloadData()
        
    
        transView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transView.frame = UIScreen.main.bounds
        self.view.addSubview(transView)

        
        self.reasonView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3 / 1.5, animations: {    self.reasonView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            
        }, completion: {(finished: Bool) in    UIView.animate(withDuration: 0.3 / 2, animations: {   self.reasonView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            
        }, completion: {(finished: Bool) in  UIView.animate(withDuration: 0.3 / 2, animations: {            self.reasonView.transform = CGAffineTransform.identity
            
        })
            
        })
            
        })
    
        
        
    }

    
    
    
    
    @IBAction func cancelButtonClicked() {

        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        }, completion: {(finished: Bool) in    if finished {
//            self.reasonView.removeFromSuperview()
            
            self.transView.removeFromSuperview()

            }
            
        })
        
    }


    
    @IBAction func authorizeApiButtonClicked() {

        if reasonAddedArray.count == 0 {
            
            let alert = UIAlertController(title: "Alert!", message: "Please select for what reasons you are going to authorize this transaction", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            
            
            SVProgressHUD.show()

            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            
            
            for (index, _) in reasonAddedArray.enumerated() {

            
            let array:NSArray = reasonAddedArray[index] as! NSArray
            
            let AuthKey:String =  (UserDefaults.standard.object(forKey: "AuthKey") as! String)
            let url = NSString(format:"AuthorizePendingTransactions/%@/%@/%@/%@/%@/%@",AuthKey,array[1] as! CVarArg,array[2] as! CVarArg,array[3] as! CVarArg, array[4] as! CVarArg,receiptNumber)
            
            
            UserDefaults.standard.set(url, forKey:"url")
            
            
            RestApiManager.sharedInstance.getRandomUser
                {
                    json in
                    let results = json["AuthorizePendingTransactionsResult"]
                    
                    
                    
                    print(results)
                    
                    
                    if (self.reasonAddedArray.count == index+1){
                    SVProgressHUD .dismiss()
                     self.cancelButtonClicked()
                        self.toggleSection(header: CollapsibleTableViewHeader(), section: self.sectionNumber)
                        
                      self.callApi()
                    }
                    
                    
                    
                    
                    
               }
                    
                    
        }
            
        }
  

    }
    
    
    
    
    @IBAction func cancelAuthorizeButtonApi(_ sender: AnyObject)
    {
 
        
        SVProgressHUD.show()
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        
        let button = sender as! UIButton
        let index = button.tag
        sectionNumber = index
        
        
        receiptNumber = receiptArray[index] as! NSString

        
        
        
        let AuthKey:String =  (UserDefaults.standard.object(forKey: "AuthKey") as! String)
        let url = NSString(format:"CancelTrans/%@/%@",AuthKey,receiptNumber)
        
        
        
        
        
        UserDefaults.standard.set(url, forKey:"url")
        
        
        
        
        
        RestApiManager.sharedInstance.getRandomUser
            {
                json in
                let results = json["CancelTransResult"]
                
                print(results)
            
                    SVProgressHUD .dismiss()
                    self.cancelButtonClicked()
                    self.toggleSection(header: CollapsibleTableViewHeader(), section: self.sectionNumber)
                    self.callApi()
                
    
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









