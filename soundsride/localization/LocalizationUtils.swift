//
//  LocalizationUtils.swift
//  soundsride
//
//  Created by Mohamed Kari on 30.01.21.
//  Copyright © 2021 Mohamed Kari. All rights reserved.
//

import Foundation
import CoreLocation

struct Duration: Codable {
    let value: Int
}
struct Leg: Codable {
    let duration_in_traffic: Duration
}

struct Route: Codable {
    let legs: [Leg]
}

struct GoogleMapsEtaResponse: Codable {
    let routes: [Route]
}
 
class GoogleMapsEtaRequest: HttpRequest {
    
    let originLatitude: Double
    let originLongitude: Double
    let destinationLatitude: Double
    let destinationLongitude: Double
    
    init(originLatitude: Double, originLongitude: Double, destinationLatitude: Double, destinationLongitude: Double) {
        self.originLatitude = originLatitude
        self.originLongitude = originLongitude
        self.destinationLatitude = destinationLatitude
        self.destinationLongitude = destinationLongitude
    }
     
     override func getUrl() -> URL {
         var components = URLComponents()
         components.scheme = "https"
         components.host = "maps.googleapis.com"
         components.path = "/maps/api/directions/json"
         components.port = 443
         components.query =  """
                             origin=\(self.originLatitude),\(self.originLongitude)\
                             &destination=\(self.destinationLatitude),\(self.destinationLongitude)\
                             &mode=DRIVING\
                             &departure_time=now\
                             &traffic_model=best_guess
                             """
                             // &key=\(Credentials.GoogleCloudAPI)
         
         return components.url!
     }
     
     override func getMethod() -> String {
         return "GET"
     }
     
     override func getHeaders() -> Dictionary<String, String>? {
        return [:] // [
             // "Content-Type": "application/octet-stream",
             // "Ocp-Apijm-Subscription-Key": self.apiKey
         // ]
     }
     
     override func getBody() -> Data? {
         return nil
     }
    
    func getEtaSynchronously() -> Int {
        let responseData = super.sendRequestAndBlock()
        let response: GoogleMapsEtaResponse = try! JSONDecoder().decode(GoogleMapsEtaResponse.self, from: responseData!)
        let eta = response.routes.first!.legs.first!.duration_in_traffic.value
        print("eta: \(eta)")
        return eta
    }
}
 

struct LocalizationConfig {
    var closestMarkerId: Int
    
    var prePointIndex: Int
    var midPointIndex: Int
    var postPointIndex: Int
    
    var currPoint: CLLocation
    
    var locationRelativeToClosest: LocationRelativeToClosest
    
    var lastPointIndex: Int?
    var nextPointIndex: Int?
    
    var transitions: [Transition]?
}

class RevisitingManager {
    
    let referenceMarkers: [Marker]
    
    var transitionMarkerIndices = [Int]()
    
    var lastReferenceLocationId: Int = -1
    
    init(referenceMarkers: [Marker]) {
        self.referenceMarkers = referenceMarkers
        
        for (index, marker) in referenceMarkers.enumerated() {
            if marker.roadEventType != .none {
                transitionMarkerIndices.append(index)
            }
        }
        
    }
    
    func getNextTransitionMarkerIndices(nextPointIndex: Int) -> ArraySlice<Int>? {
        // TODO: Could you binary search here
        
        for (i, transitionMarkerIndex) in transitionMarkerIndices.enumerated() {
            if transitionMarkerIndex >= nextPointIndex {
                return transitionMarkerIndices[i...]
            }
        }
        
        return nil
    }
    
    func getClosestMarkerId(location: CLLocation) -> Int? {
        if self.referenceMarkers.isEmpty {
            return nil
        }
        
        var closestLocationId = 0
        var closestDistance = self.referenceMarkers[0].location.distance(from: location)
        
        for locationId in (0...self.referenceMarkers.count-1) {
            let distance = self.referenceMarkers[locationId].location.distance(from: location)
            if distance < closestDistance {
                closestDistance = distance
                closestLocationId = locationId
            }
        }
        
        return closestLocationId
    }
    
    class func getLocationRelativeToClosest(prePoint: CLLocation, midPoint: CLLocation, postPoint: CLLocation, currPoint: CLLocation) -> LocationRelativeToClosest {
        let d_pre_curr = prePoint.distance(from: currPoint)
        let d_pre_mid = midPoint.distance(from: prePoint)
        
        let d_curr_post = postPoint.distance(from: currPoint)
        let d_mid_post = midPoint.distance(from: postPoint)
        
        var locationRelativeToClosest: LocationRelativeToClosest?
        
        let d_curr_mid = currPoint.distance(from: midPoint)
        
        // Check out visualization
        if d_pre_curr <= d_pre_mid && d_curr_post >= d_mid_post {
            locationRelativeToClosest = .pre
        } else if d_pre_curr >= d_pre_mid && d_curr_post <= d_mid_post {
            locationRelativeToClosest = .post
        } else if d_pre_curr <= d_pre_mid && d_curr_post <= d_mid_post {
            locationRelativeToClosest = .twilight
        } else if d_pre_curr >= d_pre_mid && d_curr_post >= d_mid_post {
            locationRelativeToClosest = .far
        }
        
        return locationRelativeToClosest!
    }
    
    
    class func getLastAndNextPointIndex(closestMarkerId: Int, locationRelativeToClosest: LocationRelativeToClosest) -> (Int?, Int?) {
        var lastPointIndex: Int?
        var nextPointIndex: Int?
        
        switch locationRelativeToClosest {
            case .pre:
                lastPointIndex = closestMarkerId - 1
                nextPointIndex = closestMarkerId
            case .post:
                lastPointIndex = closestMarkerId
                nextPointIndex = closestMarkerId + 1
            case .far:
                lastPointIndex = nil
                nextPointIndex = closestMarkerId + 1
            case .twilight:
                lastPointIndex = closestMarkerId - 1
                nextPointIndex = closestMarkerId + 1
        }
        
        return (lastPointIndex, nextPointIndex)
    }
    
    
    func getAggregateMeasure(fromInclusivly: Int, toInclusively: Int) -> (Double, Double) {
        var aggregateDistance: Double = 0.0
        var aggregateETA: Double = 0.0
        
        if fromInclusivly == toInclusively {
            return (0.0, 0)
        }
        
        for i in (fromInclusivly ... toInclusively - 1) {
            let curr = referenceMarkers[i]
            let next = referenceMarkers[i + 1]
            
            let distanceDelta = curr.location.distance(from: next.location)
            let etaDelta = curr.location.timestamp.distance(to: next.location.timestamp)
            
            aggregateDistance += Double(distanceDelta)
            aggregateETA += Double(etaDelta)
        }
        
        return (aggregateDistance, aggregateETA)
    }
    
    func getAggregateMeasureFromGoogleMaps(currentLocation: CLLocation, to: Int) -> (Double, Double)  {
        let request = GoogleMapsEtaRequest(
            originLatitude: currentLocation.coordinate.latitude,
            originLongitude: currentLocation.coordinate.longitude,
            destinationLatitude: referenceMarkers[to].location.coordinate.latitude,
            destinationLongitude: referenceMarkers[to].location.coordinate.longitude
        )
        
        return (0.0, Double(request.getEtaSynchronously()))
    }
    
    func computeTransitionSpec(currentLocation: CLLocation, nextPointIndex: Int) -> [Transition] {
        var transitions = [Transition]()
        
        for transitionMarkerIndex in self.transitionMarkerIndices {
            var transition: Transition
            
            if transitionMarkerIndex < nextPointIndex {
                transition = Transition.with { transition in
                    transition.estimatedTimeToTransition = -1.0
                    transition.estimatedGeoDistanceToTransition = -1.0
                    transition.transitionToGenre = referenceMarkers[transitionMarkerIndex].roadEventType.rawValue
                    transition.transitionID = String(transitionMarkerIndex)
                }
            } else if transitionMarkerIndex == nextPointIndex {
                transition = Transition.with { transition in
                    transition.estimatedTimeToTransition = 0.0
                    transition.estimatedGeoDistanceToTransition = 0.0
                    transition.transitionToGenre = referenceMarkers[transitionMarkerIndex].roadEventType.rawValue
                    transition.transitionID = String(transitionMarkerIndex)
                }
            }
            else {
                // let (aggregateDistance, aggregateETA) = getAggregateMeasureFromGoogleMaps(currentLocation: currentLocation, to: transitionMarkerIndex)
                let (aggregateDistance, aggregateETA) = getAggregateMeasure(fromInclusivly: nextPointIndex, toInclusively: transitionMarkerIndex)
                
                
                
                transition = Transition.with { transition in
                    transition.estimatedTimeToTransition = Float(aggregateETA)
                    transition.estimatedGeoDistanceToTransition = Float(aggregateDistance)
                    transition.transitionToGenre = referenceMarkers[transitionMarkerIndex].roadEventType.rawValue
                    transition.transitionID = String(transitionMarkerIndex)
                }
            }
            
            transitions.append(transition)
            
        }
        
        return transitions
    }
    
    func getLocalizationConfig(currentLocation: CLLocation) -> LocalizationConfig? {
        guard let closestMarkerId = self.getClosestMarkerId(location: currentLocation) else {
            return nil
        }
        
        if (closestMarkerId == 0) || (closestMarkerId == self.referenceMarkers.count - 1) {
            return nil
        }
        
        let locationRelativeToClosest = RevisitingManager.getLocationRelativeToClosest(
            prePoint: referenceMarkers[closestMarkerId - 1].location,
            midPoint: referenceMarkers[closestMarkerId].location,
            postPoint: referenceMarkers[closestMarkerId + 1].location,
            currPoint: currentLocation)
        
        let (lastPointIndex, nextPointIndex) = RevisitingManager.getLastAndNextPointIndex(closestMarkerId: closestMarkerId, locationRelativeToClosest: locationRelativeToClosest)
        
        var transitions: [Transition] = [Transition]()
        if let nextPointIndex = nextPointIndex {
            transitions = computeTransitionSpec(currentLocation: currentLocation, nextPointIndex: nextPointIndex)
            print(transitions)
        }
        
        return LocalizationConfig(
            closestMarkerId: closestMarkerId,
            prePointIndex: closestMarkerId - 1,
            midPointIndex: closestMarkerId,
            postPointIndex: closestMarkerId + 1,
            
            currPoint: currentLocation,
            locationRelativeToClosest: locationRelativeToClosest,
            lastPointIndex: lastPointIndex,
            nextPointIndex: nextPointIndex,
            
            transitions: transitions)
    }
    
}

enum LocationRelativeToClosest {
    case pre
    case post
    case twilight
    case far
}

