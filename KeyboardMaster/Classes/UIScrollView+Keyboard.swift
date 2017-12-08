//
//  UIScrollView+Keyboard.swift
//  KeyboardMaster
//
//  Created by Lucas Best on 12/6/17.
//

import UIKit

public extension UIScrollView{
    private struct ScrollViewInset{
        static var contentInsetBeforeKeyboard:UIEdgeInsets = UIEdgeInsets.zero
    }
    
    public func registerForKeyboardEvents(){
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
            self.updateKeyboardFrame(from: notification, up:true)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.updateKeyboardFrame(from: notification, up:false)
        }
    }
    
    public func deregisterFromKeyboardEvents(){
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateKeyboardFrame(from notification:Notification, up:Bool){
        if up{
             ScrollViewInset.contentInsetBeforeKeyboard = self.contentInset
        }
        
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect{
            let convertedKeyboardFrame = self.superview?.convert(keyboardFrame, from: nil) ?? keyboardFrame
            
            let intersectionRect = self.frame.intersection(convertedKeyboardFrame)
    
            var newContentInset = self.contentInset
            
            let newContentInsetBottom = self.frame.origin.y + self.frame.size.height - intersectionRect.origin.y
           
            if newContentInsetBottom > 0{
                newContentInset.bottom = newContentInsetBottom
            }
            else{
                newContentInset.bottom = ScrollViewInset.contentInsetBeforeKeyboard.bottom
            }
            
            self.contentInset = newContentInset
            self.scrollIndicatorInsets = newContentInset
        }
    }
}
