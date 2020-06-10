        //
        //  GoogleSignIn.swift
        //  ShareBox
        //
        //  Created by 廖逸澤 on 2020/5/24.
        //  Copyright © 2020 廖逸澤. All rights reserved.
        //
        
        import Foundation
        import Firebase
        import GoogleSignIn
        
        extension  ViewController   {
            
          
               
                
            
            // Do any additional setup after loading the view.
            func GoogleSignInFirst(){
             
             
                
            }
             
            @IBAction func signInButton(_ sender: Any) {
                GIDSignIn.sharedInstance().signIn()
                
            }
            @IBAction func LogOut(_ sender: Any) {
                //        GIDSignIn.sharedInstance()?.signOut()
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error)
                }
                
                print("登出\(Auth.auth().currentUser?.email ?? "N/A")")
            }
            
            @IBAction func currentUser(_ sender: Any) {
                
                guard let user = Auth.auth().currentUser?.email else { print("沒有使用者")
                    return}
                print(user)
            }
            @IBAction func add(_ sender: Any) {
                FIRFirestoreService.shared.create()
                
            }
            @IBAction func read(_ sender: Any) {
                
                FIRFirestoreService.shared.read { (data) in
                    self.texblabel.text = data as? String
                   
                }
                
                self.view.reloadInputViews()
            }
            
            @IBAction func update(_ sender: Any) {
                FIRFirestoreService.shared.update()
            }
            
            @IBAction func deleteData(_ sender: Any) {
                FIRFirestoreService.shared.delete()
            }
            
               
            
            
        }
