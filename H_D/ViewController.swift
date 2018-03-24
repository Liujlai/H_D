//
//  ViewController.swift
//  H_D
//
//  Created by idea on 2018/3/24.
//  Copyright © 2018年 idea. All rights reserved.
//

import UIKit
import WebKit
import Cupcake

class ViewController: UIViewController {
    
    var theWebView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://localhost:63342/h/index.html")
        //        let url = URL(string: "http://192.168.2.1:8080/web/#/home")
        
        let request = URLRequest(url:url!)
        
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self, name: "interOpOF")
        
        //将浏览器视图全屏(在内容区域全屏,不占用顶端时间条)
        let frame = CGRect(x:0, y:20, width:UIScreen.main.bounds.width,
                           height:UIScreen.main.bounds.height)
        theWebView = WKWebView(frame:frame, configuration: theConfiguration)
        //禁用页面在最顶端时下拉拖动效果
        theWebView!.scrollView.bounces = false
        //加载页面
        theWebView!.load(request)
        self.view.addSubview(theWebView!)
        var s = 0
        Label.str("点击+1").bg("cyan").align(.center).pin(80,50).pin(.center).addTo(view).onClick { (_) in
            s=s+1
            self.theWebView?.evaluateJavaScript("addToCar('\(s)')", completionHandler: nil)
            }.radius(-1).shadow(0.7)
        
        //        View.bg("red").pin(.xywh(50, 80, 120, 50)).radius(-1).shadow(0.7).addTo(view)
        //        Button.bg("red").pin(.xywh(50, 150, 120, 50)).radius(-1).shadow(0.7).addTo(view)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



extension ViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let sentData = message.body as! Dictionary<String,String>
        print("\(sentData)")
        if(sentData["method"] == "addTOCarCheeck"){
            let itemName = sentData["name"]!
            Alert.title("系统提示").message("确认+1？").action("取消").action("确认", {
                print("点击了确认")
                self.theWebView?.evaluateJavaScript("addToCar('\(itemName)')", completionHandler: nil)
            }).show()
        }else{
            Alert.title("系统提示").message(sentData["method"] ?? "" ).action("确认").show()
        }
    }
    
    //    js 代码
    /**
     //点击方法
     function changeView(btn){
     var message = {"method":"addTOCarCheeck","name":"222"};
     window.webkit.messageHandlers.interOpOF.postMessage(message)
     }
     //给数量+1
     function addToCar(itemName){
     var num = parseInt($("#cartNums").text());
     $("#cartNums").text(num+1);
     }
     */
}


