import Foundation

public class Point{
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
        self.dist = 0
    }
    public var x: Double
    public var y: Double
    public var dist: Double
    
    public static func findCenter(_ centerPoint: inout Point, _ a: Point, _ b: Point, _ c: Point) -> Double{
        let p = Point(b.x-a.x, b.y-a.y)
        let q = Point(c.x-a.x, c.y-a.y)
        let p2 = pow(p.x, 2) + pow(p.y, 2)
        let q2 = pow(q.x, 2) + pow(q.y, 2)
        let d = 2 * (p.x*q.y - p.y*q.x)
        if (d == 0){return 0}
        let x = (q.y*p2 - p.y*q2)/d
        let y = (p.x*q2 - q.x*p2)/d
        centerPoint.x = a.x+x
        centerPoint.y = a.y+y
        return pow(x, 2) + pow(y, 2)
    }
    
    public static func sqDist(_ p0: Point, _ p1: Point) -> Double{
        return pow(p0.x - p1.x, 2) + pow(p0.y - p1.y, 2)
    }
    
    
    public static func plane_cross(_ p0: Point, _ p1: Point, _ p2: Point) -> Double{
        return (p1.x-p0.x) * (p2.y-p0.y) - (p1.y-p0.y) * (p2.x-p0.x)
    }
    
    public func isVisible(_ e: Edge) -> Bool{
        if Point.plane_cross(self, e.p[0], e.p[1]) > 0{
            return true
        }
        return false
    }
    
    public func isNotVisible(_ e: Edge) -> Bool{
        return !isVisible(e)
    }
}

public class Edge{
    public init(_ p0: Point, _ p1: Point, _ t0: Triangle) {
        p = [p0, p1]
        t = [t0, nil]
    }
    public var p: [Point]
    public var t: [Triangle?]
    public var flipcount: Int = 0
}

public class Triangle{
    public var p: [Point]
    public var e: [Edge?]
    public var cc: Point
    public var ccr2: Double
    
    public init(_ p0: Point, _ p1: Point, _ p2: Point) {
        p = [p0, p1, p2]
        e = [nil, nil, nil]
        self.cc = Point(0, 0)
        self.ccr2 = Point.findCenter(&self.cc, p0, p1, p2)
    }
}
