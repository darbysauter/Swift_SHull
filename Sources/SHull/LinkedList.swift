import Foundation

public class LinkedList<T>{
    public var next: LinkedList<T>?
    public var prev: LinkedList<T>?
    public var data: T
    
    public init(_ data: T){
        self.data = data
    }
    
    
    public static func insertBefore(_ node: LinkedList<T>?, _ data: T) -> LinkedList<T>{
        let newNode = LinkedList<T>(data)
        newNode.data = data
        if node != nil{
            if node!.prev != nil{
                node!.prev!.next = newNode
            }
            newNode.prev = node!.prev
            newNode.next = node
            node!.prev = newNode
        }
        return newNode
    }
    
    public static func insertAfter(_ node: LinkedList<T>?, _ data: T) -> LinkedList<T>{
        let newNode = LinkedList<T>(data)
        newNode.data = data
        if node != nil{
            if node!.next != nil{
                node!.next!.prev = newNode
            }
            newNode.prev = node
            newNode.next = node!.next
            node!.next = newNode
            if node!.prev === node{
                node!.prev = newNode
            }
        }
        return newNode
    }
    
    public static func glue(_ prev: LinkedList<T>?, _ next: LinkedList<T>?){
        if prev != nil{
            prev!.next = next
        }
        if next != nil{
            next!.prev = prev
        }
    }
    
    
    public static func cfind_r(reverse: Bool,
                               begin: LinkedList<T>?,
                               fn: (T) -> Bool) -> LinkedList<T>?{
        if begin == nil {
            print("ERROR PASSED NIL")
            return nil
        }
        var counter = 0
        var iterator = begin
        if !reverse{
            repeat {
                counter += 1
                if (fn(iterator!.data)){
                    return iterator
                }
                iterator = iterator!.next
            } while iterator !== begin && iterator != nil
        }else{
            repeat {
                counter += 1
                if (fn(iterator!.data)){
                    return iterator
                }
                iterator = iterator!.prev
            } while iterator !== begin && iterator != nil
        }
        print("ERROR FIND rev: \(reverse) count: \(counter) len: \(LinkedList<T>.length(begin))")
        return nil
    }
    
    public static func cutBefore(_ node: LinkedList<T>?) -> LinkedList<T>?{
        if node == nil { return nil }
        let prev = node!.prev
        if prev == nil { return nil }
        node!.prev = nil
        prev!.next = nil
        return prev
    }
    
    public static func cutAfter(_ node: LinkedList<T>?) -> LinkedList<T>?{
        if node == nil { return nil }
        let next = node!.next
        if next == nil { return nil }
        node!.next = nil
        next!.prev = nil
        return next
    }
    
    public static func length(_ node: LinkedList<T>?) -> Int{
        var len = 0
        var iter = node
        while iter != nil {
            len += 1
            iter = iter!.next
            if iter === node{
                return len
            }
        }
        return len
    }
}
