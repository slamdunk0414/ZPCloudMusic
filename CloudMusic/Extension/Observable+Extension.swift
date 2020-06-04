//
//  ObservableExtend.swift
//  扩展Observable
//  添加了一些解析对象的方法
//
//  Created by 张鹏 on 2020/6/3.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

//导入响应式编程框架
import RxSwift

//导入JSON解析框架
import HandyJSON

//导入网络框架
import Moya

import Alamofire

/// 自定义错误
///
/// - objectMapping: 表示JSON解析为对象失败
public enum IxueaError: Swift.Error {
    case objectMapping
}

// MARK: - 扩展Observable
extension Observable {
    
    /// 将字符串解析为对象
    ///
    /// - Parameter type: 要转为的类
    /// - Returns: 转换后的观察者对象
    public func mapObject<T: HandyJSON>(_ type: T.Type) -> Observable<T?> {
        
        return self.map { data in
            //将参数尝试转为字符串
            guard let dataString = data as? String else {
                //data不能转为字符串
                return nil
            }
            
            if dataString.isEmpty {
                //空字符
                //也返回nil
                return nil
            }
            
            guard let result = type.deserialize(from: dataString) else {
                //转为对象失败
                throw IxueaError.objectMapping
            }
            
            //解析成功
            //返回解析后的对象
            return result
        }
        
    }
    
    
}

//http网络请求观察者
public class HttpObserver<Element>: ObserverType {
    
    /// ObserverType协议中用到了泛型E
    /// 所以说子类中就要指定E这个泛型
    /// 不然就会报错
    public typealias E = Element
    
    /// 请求成功回调
    var onSuccess: ((E) -> Void)
    
    /// 请求失败回调
    var onError: ((String?) -> Void)
    

    /// 构造方法
    ///
    /// - Parameters:
    ///   - onSuccess: 请求成功的回调
    ///   - onError: 请求失败的回调
    init(_ onSuccess: @escaping ((E) -> Void),_ onError: @escaping ( (String?) -> Void) ) {
        self.onSuccess = onSuccess
        self.onError = onError
    }
    
    
    /// 当RxSwift框架里面发送了事件回调
    ///
    /// - Parameter event: <#event description#>
    public func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            //next事件
            print("HttpObserver next:\(value)")
            
            //将值尝试转为BaseResponse
            let baseResponse = value as? BaseResponse
            
            if let _ = baseResponse?.status {
                
//                let e:Error = Error()
                let error = NSError(domain: baseResponse?.message ?? "未知错误", code: baseResponse?.status ?? 1, userInfo: nil)
                
                //有状态码
                //表示请求出错了
                requestErrorHandler(error: error)
            }else {
                //请求正常
                onSuccess(value)
            }
        case .error(let error):
            onError("网络好像不太好")
            
        case .completed:
            //请求完成
            print("HttpObserver completed")
        }
    }
    
    /// 处理请求错误
    ///
    /// - Parameters:
    ///   - baseResponse: 请求返回的对象
    ///   - error: 错误信息
    func requestErrorHandler(error:NSError?=nil) {
        
        let errorMessage = handleError(error:error)
        
        onError(errorMessage)
    }
    
    func handleError(error:NSError?) ->String {

        //响应码
        let code:Int=error?.code ?? 1
        
        var errorMessage:String!
        
        switch code {
        case 401:
            //表示要登录
            //弹出提示
//            ToastUtil.short("登录信息过期，请重新登录！")
            errorMessage = "登录信息过期，请重新登录！"
            
        case 403:
//            ToastUtil.short("你没有权限访问！")
            errorMessage = "你没有权限访问！"
        case 404:
//            ToastUtil.short("你访问的内容不存在！")
            errorMessage = "你访问的内容不存在！"
        case 500...599:
//            ToastUtil.short("服务器错误，请稍后再试！")
            errorMessage = "服务器错误，请稍后再试！"
            
        default:
            errorMessage = "未知错误"
            
           
        }
        
         return errorMessage
    }
    
}


// MARK: - 扩展ObservableType
// 目的是添加两个自定义监听方法
// 一个是只观察请求成功的方法
// 一个既可以观察请求成功也可以观察请求失败
extension ObservableType {
    
    /// 观察成功和失败事件
    ///
    /// - Parameters:
    ///   - onSuccess: 请求成功的回调
    ///   - onError: 请求失败的回调
    func subscribe( _ onSuccess: @escaping ((E) -> Void), _ onError: @escaping ((String?)->Void) ) -> Disposable {
        
        //创建一个Disposable
        let disposable = Disposables.create()
 
        //创建一个HttpObserver
        let observer = HttpObserver<E>(onSuccess,onError)
        
        //创建并返回一个Disposables
        return Disposables.create(self.asObservable().subscribe(observer),disposable)
    }
    
//    /// 观察成功的事件
//    ///
//    /// - Parameter onSuccess: 成功回调
//    func subscribeOnSuccess(_ onSuccess: @escaping ((E) -> Void) ) -> Disposable {
//        let disposable = Disposables.create()
//
//        let observer = HttpObserver<E>(onSuccess,nil)
//
//        return Disposables.create(self.asObservable().subscribe(observer),disposable)
//    }
}
