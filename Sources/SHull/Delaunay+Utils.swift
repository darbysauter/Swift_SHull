import Foundation

extension Delaunay{
    
    public static func findCommonIndex(_ tri: Triangle, _ point: Point) -> Int{
        for i in 0..<3{
            if point === tri.p[i]{
                return i
            }
        }
        return -1
    }
    
    public static func flipIfNecessary(_ edge: Edge, _ fd: inout Flipdata){
        if edge.t[0] != nil && edge.t[1] != nil{
            let a0 = findCommonIndex(edge.t[0]!, edge.p[0])
            let a1 = findCommonIndex(edge.t[1]!, edge.p[0])
            let b0 = findCommonIndex(edge.t[0]!, edge.p[1])
            let b1 = findCommonIndex(edge.t[1]!, edge.p[1])
            
            let c: Int = 3 ^ a0 ^ b0
            let d: Int = 3 ^ a1 ^ b1
            
            if a0 == -1 || a1 == -1 || b0 == -1 || b1 == -1{
                print("ERROR flipping")
            }
            // IF MAXRADIUS
            
            if (edge.t[0]!.ccr2 > Point.sqDist(edge.t[0]!.cc, edge.t[1]!.p[d]) || edge.t[1]!.ccr2 > Point.sqDist(edge.t[1]!.cc, edge.t[0]!.p[c])){
                edge.flipcount += 1
                if edge.flipcount > fd.maxFlips{
                    print("ERROR max flips")
                    return
                }
                fd.flipped = true
                
                let t1eb1 = edge.t[1]!.e[b1]
                let t0ea0 = edge.t[1]!.e[a0]
                
                
                edge.p[0] = edge.t[0]!.p[c]
                edge.p[1] = edge.t[1]!.p[d]
                
                edge.t[0]!.p[b0] = edge.t[1]!.p[d]
                
                edge.t[0]!.e[a0] = edge
                edge.t[0]!.e[c] = t1eb1
                
                edge.t[1]!.p[a1] = edge.t[0]!.p[c]
                
                edge.t[1]!.e[b1] = edge
                edge.t[1]!.e[d] = t0ea0
            }
        }
    }
    
    public static func mapFlipIfNecessary(_ node: LinkedList<Edge>?, _ fd: inout Flipdata){
        var iter = node
        while iter != nil{
            flipIfNecessary(iter!.data, &fd)
            iter = iter!.next
        }
    }
    
    public static func mapFindHighestFlipcount(_ node: LinkedList<Edge>?, _ fc: inout Int){
        var iter = node
        while iter != nil{
            findHighestFlipcount(iter!.data, &fc)
            iter = iter!.next
        }
    }
    
    public static func findHighestFlipcount(_ edge: Edge, _ fc: inout Int){
        if fc < edge.flipcount{
            fc = edge.flipcount
        }
    }
    
    public static func timeFunction(title: String, fn: ()->()){
        let start = CFAbsoluteTimeGetCurrent()
        fn()
        let total = CFAbsoluteTimeGetCurrent() - start
        print("Time elapsed for \(title): \(total)s")
    }
    
    public static func timeFunction(fn: ()->()) -> Double{
        let start = CFAbsoluteTimeGetCurrent()
        fn()
        return CFAbsoluteTimeGetCurrent() - start
    }
}
