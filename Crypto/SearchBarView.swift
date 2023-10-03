//
//  SearchBarView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/21.
//

import SwiftUI

struct SearchBarView: View {
    
    
    @Binding var searchText: String//绑定任意值，可以将组件与数据解耦，一般绑定ViewModel层的数据
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent//存在输入时搜索图标变色
                )
            
            TextField("Search by name or symbol", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .autocorrectionDisabled(true)//停用输入提示
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            //shared为UIApplication的单例
                            UIApplication.shared.endEditing()//停止编辑操作并关闭键盘
                            searchText = ""//清除输入内容
                        }
                    ,
                    alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)//会成为一个圆形
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/,
                    x:0,
                    y:0
                )
        )
        .padding()
    }
}

struct SearchBarView_PreviewProvider:PreviewProvider {
    static var previews: some View{
        Group{
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)//设置背景模式
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
    
}
