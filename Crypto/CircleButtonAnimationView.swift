//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/6.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding  var animate: Bool //Binding值不能是private类型的
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)//动画结束时隐藏
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: animate)//绑定动画，当动画开关开启时，启动渐进动画
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100,height: 100,alignment: .center)
    }
}
