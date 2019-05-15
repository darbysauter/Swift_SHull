import Foundation

extension Delaunay {
    public struct Flipdata{
        public var maxFlips: Int
        public var flipped: Bool
        public init(_ maxFlips: Int, _ flipped: Bool){
            self.maxFlips = maxFlips
            self.flipped = flipped
        }
    }
    
    public struct TriangulationData{
        public var triangles: LinkedList<Triangle>?
        public var hullEdges: LinkedList<Edge>?
        public var internalEdges: LinkedList<Edge>?
        
        public init(){}
    }
}
