public func test() -> Bool{
    let numPoints = 10000
    var randPoints = [Point?](repeating: nil, count: numPoints)
    
    for i in 0..<numPoints{
        let x = Double.random(in: 0...1000)
        let y = Double.random(in: 0...1000)
        let p = Point(x, y)
        randPoints[i] = p
    }
    
    var td = Delaunay.TriangulationData()
    var points = randPoints as! [Point]
    Delaunay.timeFunction(title: "delaunay \(numPoints) points") {
        Delaunay.delaunay(&td, &points)
    }
    
    return true
}
