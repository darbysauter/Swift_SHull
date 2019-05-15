import Foundation

class Delaunay {
    static func findSmallestDist(_ points: inout [Point]){
        let p0 = points[0]
        var smallestDist: Double = Double.greatestFiniteMagnitude
        var indexOfSmallest: Int = -1
        for i in 1..<points.count{
            let dist = Point.sqDist(p0, points[i])
            points[i].dist = dist
            if dist < smallestDist{
                smallestDist = dist
                indexOfSmallest = i
            }
        }
        points.swapAt(1, indexOfSmallest)
    }
    
    static func sqCircumradius(_ a: Point, _ b: Point, _ c: Point) -> Double{
        let p = Point(b.x-a.x, b.y-a.y)
        let q = Point(c.x-a.x, c.y-a.y)
        let p2 = pow(p.x, 2) + pow(p.y, 2)
        let q2 = pow(q.x, 2) + pow(q.y, 2)
        let d = 2 * (p.x*q.y - p.y*q.x)
        if (d == 0){
            print("ERROR d")
            return -1
        }
        let x = (q.y*p2 - p.y*q2)/d
        let y = (p.x*q2 - q.x*p2)/d
        return pow(x, 2) + pow(y, 2)
    }
    
    static func findSmallestCircumcircle(_ points: inout [Point], _ randPoint: Int){
        let c = points[0]
        let b = points[1]
        var smallestRadius: Double = Double.greatestFiniteMagnitude
        var indexOfSmallest: Int = -1
        let radius1 = sqCircumradius(points[2], b, c)
        if radius1 == -1{print("ERROR DEGENERATE CASE")}
        for i in 2..<points.count{
            let radius = sqCircumradius(points[i], b, c)
            if radius < smallestRadius{
                smallestRadius = radius
                indexOfSmallest = i
            }
        }
        if smallestRadius <= -1{
            print("ERROR radius")
            return
        }
        points.swapAt(2, indexOfSmallest)
    }
    
    static func radialSort(_ points: inout ArraySlice<Point>, _ centerPoint: Point){
        points.sort { (p0, p1) -> Bool in
//            let p0Dist = Point.sqDist(p0, centerPoint)
//            let p1Dist = Point.sqDist(p1, centerPoint)
//            return p0Dist < p1Dist
            return p0.dist < p1.dist
        }
    }
    
    static func seedTriangulation(_ td: inout TriangulationData, _ points: [Point]){
        let tri = Triangle(points[0], points[1], points[2])
        let e0 = Edge(points[2], points[0], tri)
        let e1 = Edge(points[1], points[2], tri)
        let e2 = Edge(points[0], points[1], tri)
        
        tri.e[0] = e1
        tri.e[1] = e0
        tri.e[2] = e2
        
        td.triangles = LinkedList<Triangle>.insertAfter(nil, tri)
        
        td.hullEdges = LinkedList<Edge>.insertAfter(nil, e0)
        LinkedList<Edge>.glue(td.hullEdges, td.hullEdges) // makes linked list circular
        LinkedList<Edge>.insertAfter(td.hullEdges, e1)
        LinkedList<Edge>.insertAfter(td.hullEdges, e2)
    }
    
    static func addPointsToHull(_ td: inout TriangulationData, _ points: ArraySlice<Point>){
        for point in points{
            var firstVis: LinkedList<Edge>?
            var lastVis: LinkedList<Edge>?
            var firstHid: LinkedList<Edge>?
            var lastHid: LinkedList<Edge>?
            
            if td.hullEdges == nil{ print("ERROR hull") }
            if point.isVisible(td.hullEdges!.data){
                firstHid = LinkedList<Edge>.cfind_r(reverse: false, begin: td.hullEdges, fn: point.isNotVisible)
                lastHid = LinkedList<Edge>.cfind_r(reverse: true, begin: td.hullEdges, fn: point.isNotVisible)
                firstVis = LinkedList<Edge>.cutAfter(lastHid)
                lastVis = LinkedList<Edge>.cutBefore(firstHid)
            }else{
                firstVis = LinkedList<Edge>.cfind_r(reverse: false, begin: td.hullEdges, fn: point.isVisible)
                lastVis = LinkedList<Edge>.cfind_r(reverse: true, begin: td.hullEdges, fn: point.isVisible)
                firstHid = LinkedList<Edge>.cutAfter(lastVis)
                lastHid = LinkedList<Edge>.cutBefore(firstVis)
            }
            
            var e0: Edge?
            var e1: Edge?
            
            var n = firstVis
            
            while n != nil{
                let edge = n!.data
                let tri = Triangle(edge.p[0], point, edge.p[1])
                
                td.triangles = LinkedList<Triangle>.insertBefore(td.triangles, tri)
                
                edge.t[1] = tri
                if n === firstVis{
                    e0 = Edge(edge.p[0], point, tri)
                    lastHid = LinkedList<Edge>.insertAfter(lastHid, e0!)
                }else{
                    e0 = e1
                    e0!.t[1] = tri
                    td.internalEdges = LinkedList<Edge>.insertBefore(td.internalEdges, e0!)
                }
                
                e1 = Edge(point, edge.p[1], tri)
                
                tri.e[0] = e1!
                tri.e[1] = edge
                tri.e[2] = e0!
                
                if n === lastVis{
                    lastHid = LinkedList<Edge>.insertAfter(lastHid, e1!)
                }
                n = n!.next
            }
            LinkedList<Edge>.glue(lastVis, td.internalEdges)
            td.internalEdges = firstVis
            LinkedList<Edge>.glue(lastHid, firstHid)
            td.hullEdges = firstHid
        }
    }
    
    static func makeDelaunay(_ td: TriangulationData) -> Int{
        var fd = Flipdata(Int(pow(Double(LinkedList<Edge>.length(td.internalEdges)), 2)), true)
        while fd.flipped{
            fd.flipped = false
            Delaunay.mapFlipIfNecessary(td.internalEdges, &fd)
        }
        var flipcount = 0
        Delaunay.mapFindHighestFlipcount(td.internalEdges, &flipcount)
        return flipcount
    }
    
    static func delaunay(_ td: inout TriangulationData, _ points: inout [Point], _ randPoint: Int = 0){
        if points.count == 0 || randPoint == points.count {return}
        if randPoint != 0{
            points.swapAt(0, randPoint)
        }
        // Select seed point
        findSmallestDist(&points)   // Index 0 is random point, Index 1 is closest point to Index 0
        
        findSmallestCircumcircle(&points, randPoint)    // Index 2 is point that forms
        // smallest circumcircle with index 0 and 1
        
        let cross = Point.plane_cross(points[0], points[1], points[2])
        if cross > 0{
            points.swapAt(1, 2)
        }else if cross == 0{
            print("ERROR cross prod")
            return delaunay(&td ,&points, randPoint + 1)
        }
        
        
        var centerPoint = Point(0,0)
        let radius = Point.findCenter(&centerPoint, points[0], points[1], points[2])
        if radius < 0{
            print("ERROR radius")
            return delaunay(&td, &points, randPoint + 1)
        }
        
        if (points.count > 4){
            radialSort(&points[3...], centerPoint)
        }
        
        
        seedTriangulation(&td, points)
        
        addPointsToHull(&td, points[3...])
    }
}
