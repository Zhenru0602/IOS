//
//  LoginViewController.swift
//  EventTime
//
//  Created by mac on 6/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var emailButton: UIButton!
    
    let images = [Int](0...Constants.Values.imageCount.rawValue).map({String($0)})
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogin()
        
 
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupScrollView()
        
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        
        guard pageControl.currentPage >= 0 else {
            return
        }
        
        pageControl.currentPage -= 1
        
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        scrollView.layoutIfNeeded()
        
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        guard pageControl.currentPage <= images.count - 1 else {
            return
        }
        
        pageControl.currentPage += 1
        
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        scrollView.layoutIfNeeded()
        
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {

        emailLoginAlert()
        
    }
    
    
    //MARK: Helper
    
    func dismissTab(_ tabController: UITabBarController) {
        tabController.dismiss(animated: true, completion: nil)
        print("Dismissed TabBarController")
    }
    
    //MARK: Setup
    
    func setupScrollView() {
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        
        for number in 0..<images.count {
            
            frame.origin.x = scrollView.frame.size.width * CGFloat(number)
            
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[number])
            
            scrollView.addSubview(imageView)
        }
    }
    
    func setupLogin() {
        
        pageControl.numberOfPages = images.count
        scrollView.delegate = self
        googleButton.layer.cornerRadius = googleButton.layer.frame.height / 2
       
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    //MARK: Alert
    func emailLoginAlert() {
        let alert = UIAlertController(title: "Email Login", message: "Enter email and password to login", preferredStyle: UIAlertController.Style.alert)
        //Step : 2
        let save = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            Auth.auth().signIn(withEmail: textField.text!, password: textField2.text!) { [unowned self] user, error in
                if let err = error{
                    print("Fail to Login with error: \(err.localizedDescription)")
                    return
                }
                
                let credential = EmailAuthProvider.credential(withEmail: textField.text!, password: textField2.text!)
                
                
                
                Auth.auth().signIn(with: credential) { [unowned self] (result, err) in
                    if let err = error {
                        print("Error Signing in: \(err.localizedDescription)")
                        return
                    }
                    
                    if let auth = result {
                        print("Successful SignIn: \(auth.user.uid)")
                        DispatchQueue.main.async {
                            let tab = self.goToHome()
                            self.present(tab, animated: true, completion: nil)
                        }
                    }
                }
                
                
            }
            
        }
        
        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your email"
        }
        //For second TF
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your password"
             textField.isSecureTextEntry = true
        }
        
        //Step : 4
        alert.addAction(save)
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }
}

//MARK: GoogleDelegate

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //First check if user signs in Google successfully
        if let err = error {
            print("Error Signing in: \(err.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        //If so, sign user in with credential from Google to Firebase
        Auth.auth().signIn(with: credential) { [unowned self] (result, err) in
            if let err = error {
                print("Error Signing in: \(err.localizedDescription)")
                return
            }
            
            if let auth = result {
                print("Successful SignIn: \(auth.user.uid)")
                DispatchQueue.main.async {
                    let tab = self.goToHome()
                    self.present(tab, animated: true, completion: nil)
                }
            }
        }
    }
    
}



//MARK: ScrollView
extension LoginViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    
}
