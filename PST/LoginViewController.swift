//
//  LoginViewController.swift
//  PST
//
//  Created by Arafath on 11/05/17.
//
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswdTextField: UITextField!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet var menuButton:UIBarButtonItem!
    
    var fromScreen:String=""
    
    
    
    
    
    override func  viewDidLoad() {
                emailTextField.text="PST"
                pswdTextField.text="@dmiN12345"
        
//        emailTextField.text="saleem"
//        pswdTextField.text="SALEEM"
//        
        
        
    }
    
    
    
    
    
    
    
    
    
    //pragma mark - textField Delegate row lifecycle
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 250
        
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration )
        UIView.commitAnimations()
        
        
        
        
        if textField == self.emailTextField && (textField.text?.characters.count)! > 0{
            self.line1.backgroundColor=UIColor(red: 0/255.0, green:127/255.0, blue: 14/255.0, alpha: 1.0)
            self.line2.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        }
        else  if textField == self.pswdTextField && (textField.text?.characters.count)! > 0{
            self.line2.backgroundColor=UIColor(red: 0/255.0, green:127/255.0, blue: 14/255.0, alpha: 1.0)
            self.line1.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        }
        else  {
            
            self.line1.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
            self.line2.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        let movementDuration:TimeInterval = 0.35
        
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
        
        
        
        if textField == self.emailTextField {
            self.pswdTextField.becomeFirstResponder()
        }
        
        
        
    }
    
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == self.emailTextField && (textField.text?.characters.count)! > 0{
            self.line1.backgroundColor=UIColor(red: 0/255.0, green:127/255.0, blue: 14/255.0, alpha: 1.0)
            self.line2.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        }
        else  if textField == self.pswdTextField && (textField.text?.characters.count)! > 0{
            self.line2.backgroundColor=UIColor(red: 0/255.0, green:127/255.0, blue: 14/255.0, alpha: 1.0)
            self.line1.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        }
        else  {
            
            self.line1.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
            self.line2.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        self.line1.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        self.line2.backgroundColor=UIColor(red: 143/255.0, green:143/255.0, blue: 143/255.0, alpha: 1.0)
        
        
        return true
    }
    
    
    
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
    
    
    
    //pragma mark - Login Button Clicking Action
    
    
    @IBAction func loginButtonClicked() {
    
        
        emailTextField.resignFirstResponder()
        pswdTextField.resignFirstResponder()
        
        
        
        
        
        let emailString: String = emailTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let pswdString = pswdTextField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        
        
        
        
        if emailString .isEmpty  {
            let alert = UIAlertController(title: "Alert!", message: "Please enter userid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else  if pswdString.isEmpty
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
            
            
        else
        {
            
            
            
            SVProgressHUD.show()
            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            
            
            
            
            
            let url = NSString(format:"GetLoginInfo/%@/%@/APPLE/DEVICETOKEN/",emailString,pswdString)
            
            
            UserDefaults.standard.set(url, forKey:"url")
            
            
            
            
            
            RestApiManager.sharedInstance.getRandomUser
                {
                    json in
                    let results = json["GetLoginInfoResult"]
                    
                    
                    
                    SVProgressHUD .dismiss()
                    
                    
                    if(results.count != 0)
                    {
                        
                        
                        
                        
                        
                        
                        let AuthKey: String = results[0]["AuthKey"].string!
                        let Username: String = results[0]["Username"].string!
                        
                        UserDefaults.standard.set(AuthKey, forKey:"AuthKey")
                        UserDefaults.standard.set(Username, forKey:"Username")
                        
                      
                        
                        let ObjMenuModelCols = results[0]["ObjMenuModelCols"]

                        
                        
                        let menuArray = NSMutableArray()
                        menuArray .add("Dashboard")

                        
                        for (_, subJson: JSON) in ObjMenuModelCols
                        {
                            let name: String = JSON["MENU_NAME"].string!
                            if(name != "Admin" && name != "Reports"){
                            menuArray .add(name)
                            }
                        }
                        
                        menuArray .add("Logout")

                        UserDefaults.standard.set(menuArray, forKey:"menuArray")

                        
                        
        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DasboardViewController") as! DasboardViewController
                        let navigationController = UINavigationController(rootViewController: destinationController)
                        sw.pushFrontViewController(navigationController, animated: true)
                        
                        
                        
                    }
                    else
                    {
                        //                        let errorMessage: String = results[0]["errorStatus"].string!
                        
                        let alert = UIAlertController(title: "Alert!", message: "Username or password invalid", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
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

