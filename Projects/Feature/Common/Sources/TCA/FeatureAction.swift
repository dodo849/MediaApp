//
//  FeatureAction.swift
//  CommonFeature
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

/// Feature Action 분리를 위한 프로토콜
public protocol FeatureAction {
    associatedtype ViewAction
    associatedtype InnerAction
    associatedtype AsyncAction
    associatedtype ScopeAction
    associatedtype DelegateAction
    
    /// View에서 접근하는 Action
    static func view(_: ViewAction) -> Self
    
    /// Reducer 내부적으로 사용되는 Action
    static func inner(_: InnerAction) -> Self
    
    /// 비동기 처리를 수행하는 Action
    static func async(_: AsyncAction) -> Self
    
    /// 자식에게 전달하는 Action
    static func scope(_: ScopeAction) -> Self
    
    /// 부모에서 주입받는 Action
    static func delegate(_: DelegateAction) -> Self
}
