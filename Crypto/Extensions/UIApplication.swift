//
//  UIApplication.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/21.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    
    func endEditing(){
        //#selector(UIResponder.resignFirstResponder)-关闭键盘，和其他编辑操作
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
