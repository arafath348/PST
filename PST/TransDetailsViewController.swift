//
//  TransDetailsViewController.swift
//  PST
//
//  Created by Arafath on 31/05/17.
//
//

import UIKit

class TransDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate {
    
    var transDetailsArray:NSArray = []
    var leftArray:NSArray = []



    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftArray = ["Currency ID ", "Trans. Type", "Trans. Amount", "Exchange Rate", "Trans. RM Amt"]
        
        revealViewController().delegate = self
        
        
        // Do any additional setup after loading the view.
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
    
    
    
    
    
    
    
    
    
    
    
    //
    // MARK: - View Controller DataSource and Delegate
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        

        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell?)!
        
            cell.leftLabel.text = leftArray[indexPath.row] as? String
        
        

        
        let array:NSArray = transDetailsArray[indexPath.section] as! NSArray
        cell.rightLabel?.text = array[indexPath.row] as? String

        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return sections[indexPath.section].collapsed! ? 0 : 44.0
//    }
//    
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44.0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1.0
//    }
//    
//    
//    
//    

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
