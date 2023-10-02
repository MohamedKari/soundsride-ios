import SwiftUI
import CoreLocation
import MapKit

enum LocationMarkerRole: String {
    case passedCurr
    case reference
    case visitedReference
    case upNext
    case twilightOrFar
}

enum RoadEventType: String {
    case none
    case tunnelEntrance
    case tunnelExit
    case highwayEntrance
    case highwayJunction
    case highwayExit
    case speedLimitRevocation
    case trafficLight
}

class MarkerTappedDelegate {
    func didTapMarker(markerIndex: Int) {
        
    }
}

struct Marker: Identifiable {
    
    var location: CLLocation
    var role: LocationMarkerRole
    var roadEventType: RoadEventType
    var index: Int
    
    var viewModel: LocalizationViewModel?
    
    let id = UUID()
    
    func getColor() -> Color {
        let colorByRole: [LocationMarkerRole: Color] = [
            .reference: .yellow,
            .visitedReference: .blue,
            .passedCurr: .black,
            .upNext: .red,
            .twilightOrFar: .gray
        ]
        
        return colorByRole[role]!
    }
    
    func getIconName() -> String {
        if roadEventType == .tunnelEntrance {
            return "tram.tunnel.fill"
        } else if roadEventType == .tunnelExit {
            return "arrow.down.right.and.arrow.up.left"
        } else if roadEventType == .highwayEntrance {
            return "arrow.triangle.merge"
        } else if roadEventType == .highwayJunction {
            return "arrow.up.right"
        } else if roadEventType == .highwayExit {
            return "arrow.triangle.branch"
        } else if roadEventType == .trafficLight {
            return "clock.arrow.circlepath"
        } else if roadEventType == .speedLimitRevocation {
            return "speedometer"
        }

        return "mappin"
    }
    
    
    func getMapAnnotation() -> some MapAnnotationProtocol {
        let size = CGFloat(20)
        
        return MapAnnotation(coordinate: location.coordinate) {
            Image(systemName: getIconName())
                .foregroundColor(getColor())
                .font(.system(size: size, weight: .bold))
                .onTapGesture(perform: {
                    print("tapped \(index)")
                    if let viewModel = viewModel {
                        if viewModel.markers[index].roadEventType == .none {
                            viewModel.markers[index].roadEventType = .tunnelEntrance
                        } else if viewModel.markers[index].roadEventType == .tunnelEntrance {
                            viewModel.markers[index].roadEventType = .tunnelExit
                        } else if viewModel.markers[index].roadEventType == .tunnelExit {
                            viewModel.markers[index].roadEventType = .highwayEntrance
                        } else if viewModel.markers[index].roadEventType == .highwayEntrance {
                            viewModel.markers[index].roadEventType = .highwayJunction
                        } else if viewModel.markers[index].roadEventType == .highwayJunction {
                            viewModel.markers[index].roadEventType = .highwayExit
                        } else if viewModel.markers[index].roadEventType == .highwayExit {
                            viewModel.markers[index].roadEventType = .trafficLight
                        } else if viewModel.markers[index].roadEventType == .trafficLight {
                            viewModel.markers[index].roadEventType = .speedLimitRevocation
                        } else if viewModel.markers[index].roadEventType == .speedLimitRevocation {
                            viewModel.markers[index].roadEventType = .none
                        }
                    }
                    
                })
        }
    }
    
    func getMapPin() -> MapPin {
        return MapPin(coordinate: location.coordinate, tint: getColor())
    }
    
    func getMarkerIdText() -> some MapAnnotationProtocol {
        return MapAnnotation(coordinate: location.coordinate) {
         Text(String(self.index))
        }
    }
    
    static func getCsvHeader() -> String{
        return
            """
            INDEX;\
            TIMESTAMP;\
            LATITUDE;\
            LONGITUDE;\
            HORIZONTAL_ACCURACY;\
            VERTICAL_ACCURACY;\
            SPEED;\
            SPEED_ACCURACY;\
            ALTITUDE;\
            COURSE;\
            COURSE_ACCURACY;\
            TRANSITION_TO
            """
        
    }
    
    static func fromCsvLine(csvLine: String, role: LocationMarkerRole = .reference, viewModel: LocalizationViewModel) -> Marker {
        
        let f = csvLine.components(separatedBy: ";") // fields
        let (index,
             timestamp,
             latitude,
             longitude,
             horizontalAccuracy,
             verticalAccuracy,
             speed,
             speedAccuracy,
             altitude,
             course,
             courseAccuracy,
             roadEventType) = (f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7], f[8], f[9], f[10], f[11])
        
        let location: CLLocation = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!),
            altitude: CLLocationDistance(altitude)!,
            horizontalAccuracy: CLLocationAccuracy(horizontalAccuracy)!,
            verticalAccuracy: CLLocationAccuracy(verticalAccuracy)!,
            course: CLLocationDirection(course)!,
            courseAccuracy: CLLocationDirectionAccuracy(courseAccuracy)!,
            speed: CLLocationSpeed(speed)!,
            speedAccuracy: CLLocationSpeedAccuracy(speedAccuracy)!,
            timestamp: Date(timeIntervalSince1970: TimeInterval(timestamp)!))
        
        let marker = Marker(location: location, role: role, roadEventType: RoadEventType(rawValue: roadEventType)!, index: Int(index)!, viewModel: viewModel)

        return marker
    }
    
    func toCsvLine() -> String {
        return
            """
            \(index);\
            \(Int64(location.timestamp.timeIntervalSince1970.rounded()));\
            \(location.coordinate.latitude);\
            \(location.coordinate.longitude);\
            \(location.horizontalAccuracy);\
            \(location.verticalAccuracy);\
            \(location.speed);\
            \(location.speedAccuracy);\
            \(location.altitude);\
            \(location.course);\
            \(location.courseAccuracy);\
            \(roadEventType)
            """
    }
    
    
}

class RecordLocationDelegate: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var viewModel: LocalizationViewModel
    
    init(viewModel: LocalizationViewModel) {
        self.viewModel = viewModel
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("RecordLocationDelegate: didUpdateLocations")
            
        if let currentLocation = locations.last {
            viewModel.mostRecentText = "Lat : \(currentLocation.coordinate.latitude) \nLng : \(currentLocation.coordinate.longitude) \n \(currentLocation.timestamp)"

            viewModel.mostRecentText = """
            Timestamp \(currentLocation.timestamp)
            Lat \(currentLocation.coordinate.latitude), Lng \(currentLocation.coordinate.longitude) Acc \(currentLocation.horizontalAccuracy)
            """
            
            let recordedMarker = Marker(location: currentLocation, role: .reference, roadEventType: .none, index: viewModel.markers.count, viewModel: viewModel)
            viewModel.markers.append(recordedMarker)
            
            viewModel.mostRecentRegion = MKCoordinateRegion(
                center: currentLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            print("mostRecentText" + "\(viewModel.mostRecentText)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }

}

class RevisitingLocationDelegate: NSObject, CLLocationManagerDelegate, ObservableObject {
    var viewModel: LocalizationViewModel
    
    init(viewModel: LocalizationViewModel) {
        self.viewModel = viewModel
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let start = DispatchTime.now()
        
        
        let SHOW_CURRENT_PATH = false
            
        if let currentLocation = locations.last {
            
            guard let localizationConfig = viewModel.revisitingManager!.getLocalizationConfig(currentLocation: currentLocation) else {
                print("Cannot determine localization configuration!")
                return
            }
            
            if (localizationConfig.closestMarkerId > 0) && (localizationConfig.closestMarkerId < viewModel.referenceMarkers!.count - 1) {
            
                
                if let nextPoint = viewModel.nextPoint {
                    viewModel.markers[nextPoint].role = .reference
                    viewModel.nextPoint = nil
                }
                
                if let lastPointIndex = localizationConfig.lastPointIndex {
                    viewModel.markers[lastPointIndex].role = .visitedReference
                }
                
                if let nextPointIndex = localizationConfig.nextPointIndex {
                    if localizationConfig.locationRelativeToClosest == .far {
                        viewModel.markers[nextPointIndex].role = .twilightOrFar
                    } else {
                        viewModel.markers[nextPointIndex].role = .upNext
                    }
                    
                    viewModel.nextPoint = nextPointIndex
                }
                
                var dashboardString = ""
                if let nextPointIndex = localizationConfig.nextPointIndex {
                    dashboardString.append("Next up: \(nextPointIndex)\n")
                }
                
                if let transitions = localizationConfig.transitions {
                    
                    
                    for transition in transitions {
                        dashboardString.append(
                            "\(transition.transitionID), \(transition.estimatedGeoDistanceToTransition), \(transition.estimatedTimeToTransition), \(transition.transitionToGenre)\n")
                    }
                    
                    let service = viewModel.soundsRideService!
                    service.updateTransitionSpec(
                        transitions: transitions,
                        currentLatitude: currentLocation.coordinate.latitude,
                        currentLongitude: currentLocation.coordinate.longitude,
                        nextUp: String(localizationConfig.nextPointIndex ?? -1))
                }
                
                viewModel.mostRecentText = dashboardString
                viewModel.mostRecentRegion = MKCoordinateRegion(
                        center: currentLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
                
                
                if  SHOW_CURRENT_PATH {
                    self.viewModel.markers.append(
                        Marker(location: currentLocation, role: .passedCurr, roadEventType: .none, index: viewModel.markers.count, viewModel: viewModel)
                    )
                }
                
                

            }
    
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            
            print("Execution time: \(timeInterval) s")

        }
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError")
        print(error)
    }
    
}

// 1: Introduce an Abstract State class
// 2: Each possible action (union over all actions in all states) is declared as a stub in the main State class and either raises an "undefined State Transition" error for each action or do nothing in each action
// 3: For each State, define a State subclass named "IdleState", "RunningStat", ...
// 4: Override the allowed actions per State returning the new State. Per overridden action in the function, de-init the transition and return the new State.


class Persistence {
    
    class func getFSCompatibleTimeStamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let timestamp = dateFormatter.string(from: date)
        return timestamp
    }
    
    class func getExportedFiles(directoryName: String) -> [String] {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryUrl = documentsURL.appendingPathComponent(directoryName)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
            let fileNames = fileURLs.map({
                $0.lastPathComponent
            })
            
            return fileNames
        }
        catch {
            return [String]()
        }
    }

    class func writeCsv(fileUrl: URL, csv: String) -> URL? {
        // In order for the files to show up in the Files app under "On my iPhone",
        // we need to set the values `UIFileSharingEnabled` and `LSSupportsOpeningDocumentsInPlace`
        // to YES in the Info.plist.
        //
        // Then, automatically, the files placed under ".documentDirectoy" with userDomainMask will show up in the Files app.
        // For hidden files user .applicationSupportDirectory instead.
        // Both folders are synchronized to the User's iCloud.
        //
        // See:
        // https://www.bignerdranch.com/blog/working-with-the-files-app-in-ios-11/
        // https://stackoverflow.com/questions/49530135/store-file-at-public-space-and-easily-accesed-by-any-file-explorer-in-swift-ios
        
        print("Writing csv to path \(fileUrl)")
        try! csv.write(to: fileUrl, atomically: true, encoding: .utf8)
        
        
        return fileUrl
    }
    
    class func mkdir(directoryName: String) throws {
        let documentPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let directoryPath = documentPath.appendingPathComponent(directoryName)
        
        let isDirectory = ObjCBool(false)
        print("folder \(directoryPath.path) does not exists: \(isDirectory.boolValue)")
        do {
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch CocoaError.fileWriteFileExists {
            print("File already exists!")
        } catch let error {
            throw error
        }
    }
    
    class func getUrl(directoryName: String, fileName: String) -> URL {
        
        let documentPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentPath.appendingPathComponent(directoryName).appendingPathComponent(fileName)
        
        return fileUrl
    }
    
    class func getFileTextByFileName(directoryName: String, fileName: String) -> String? {
        do {
            let documentUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentUrl.appendingPathComponent(directoryName).appendingPathComponent(fileName)
            let fileText = try String(contentsOf: fileURL, encoding: .utf8)
            print(fileURL)
            
            return fileText
        }
        catch {
            return nil
        }
    }
}

class LocalizationViewModel: ObservableObject {
    
    // Map
    var locationManager: CLLocationManager?
    var recordLocationDelegate: RecordLocationDelegate?
    var revisitingLocationDelegate: RevisitingLocationDelegate?
    var revisitingManager: RevisitingManager?
    
    var referenceMarkers: [Marker]?
    var lastPoint: Int?
    var nextPoint: Int?
    
    var soundsRideService: SoundsRideService?
    
    @Published var mostRecentText = ""
    @Published var markers = [Marker]()
    @Published var mostRecentRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    // Buttons
    @Published var revisitingButtonText =  ""
    @Published var recordingButtonText =  ""
    @Published var recordingButtonDisabled = true
    @Published var saveButtonDisabled = true
    @Published var resetButtonDisabled = true
    @Published var loadSavedPathPickerDisabled = true
    @Published var revisitingButtonDisabled = true
    
    // Picker
    @Published var fileNames = Persistence.getExportedFiles(directoryName: "localization")
    
    // Alert
    @Published var alertShowing = false
    @Published var alertText = ""
    
}

class LocalizationViewState {
    
    init(viewModel: LocalizationViewModel) {
        
    }
    
    func handleRecordButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        return self
    }
    
    func handleSaveButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        return self
    }
    
    func handleResetButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        return self
    }
    
    func handleLoadSavedPathPick(fileName: String, viewModel: LocalizationViewModel) -> LocalizationViewState {
        return self
    }
    
    func handleRevistingButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        return self
    }
    
}

class IdleLocalizationViewState: LocalizationViewState {
    
    let directoryName = "localization"
    
    override init(viewModel: LocalizationViewModel) {
        super.init(viewModel: viewModel)
        viewModel.recordingButtonText = "Start Recording"
        viewModel.recordingButtonDisabled = false
        viewModel.saveButtonDisabled = false
        viewModel.resetButtonDisabled = false
        viewModel.loadSavedPathPickerDisabled = false
        viewModel.revisitingButtonText = "Start Revisiting"
        viewModel.revisitingButtonDisabled = false
    }
    
    override func handleRecordButton(viewModel: LocalizationViewModel) -> LocalizationViewState{
        viewModel.locationManager = CLLocationManager()
        viewModel.recordLocationDelegate = RecordLocationDelegate(viewModel: viewModel)
        viewModel.locationManager!.delegate = viewModel.recordLocationDelegate
        viewModel.locationManager!.requestAlwaysAuthorization()
        viewModel.locationManager!.requestWhenInUseAuthorization()
        
        // Snap to Route
        // https://stackoverflow.com/questions/19815248/snap-to-road-for-apple-maps
        // http://regex.info/blog/2016-01-19/2666
        viewModel.locationManager!.activityType = .automotiveNavigation
        
        viewModel.locationManager!.startUpdatingLocation()
        
        return RecordingLocalizationViewState(viewModel: viewModel)
    }
    
    override func handleSaveButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        var csv = "\(Marker.getCsvHeader())\n"
        
        for marker in viewModel.markers {
            csv.append("\(marker.toCsvLine())\n")
        }
        
        try! Persistence.mkdir(directoryName: self.directoryName)
        let fileUrl = Persistence.writeCsv(fileUrl: Persistence.getUrl(directoryName: self.directoryName, fileName: Persistence.getFSCompatibleTimeStamp()), csv: csv)
        
        print("Wrote CSV: \n\(csv)")
        
        if let writtenFileUrl = fileUrl {
            viewModel.alertText = "Saved GPS trajectory to \(writtenFileUrl)"
        } else {
            viewModel.alertText = "Error: Couldn't save GPS trajectory..."
        }
        
        viewModel.alertShowing = true

        viewModel.fileNames = Persistence.getExportedFiles(directoryName: self.directoryName)

        return self
    }
    
    override func handleResetButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        viewModel.mostRecentText = ""
        viewModel.markers = [Marker]()
        viewModel.mostRecentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        return self
    }
    
    override func handleLoadSavedPathPick(fileName: String, viewModel: LocalizationViewModel) -> LocalizationViewState {
        let csv = Persistence.getFileTextByFileName(directoryName: self.directoryName, fileName: fileName)
        
        var annotationItems = [Marker]()
        
        // TODO: Use CSV parser lib
        // TODO: Refactor Force-Unwraps
        if let readCsv = csv {
            print("readCsv: \n\(readCsv)")
            
            let lines = readCsv.components(separatedBy: "\n")
            for line in lines[1...] {
                if line == "" {
                    continue
                }
                
                let marker = Marker.fromCsvLine(csvLine: line, role: .reference, viewModel: viewModel)
            
                annotationItems.append(marker)
            }
        } else {
            viewModel.alertText = "Error: Couldn't load GPS trajectory..."
            viewModel.alertShowing = true
            return self
        }
        
        
        viewModel.markers = annotationItems
        viewModel.mostRecentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: annotationItems.last!.location.coordinate.latitude, longitude: annotationItems.last!.location.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        
        return self
    }

    
    override func handleRevistingButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        
        
        if viewModel.markers.isEmpty {
            viewModel.alertText = "No reference path selected!"
            viewModel.alertShowing = true
        }
        
        viewModel.referenceMarkers = viewModel.markers
        viewModel.revisitingManager = RevisitingManager(referenceMarkers: viewModel.referenceMarkers!)
        
        viewModel.soundsRideService = SoundsRideService()
        
        viewModel.locationManager = CLLocationManager()
        viewModel.revisitingLocationDelegate = RevisitingLocationDelegate(viewModel: viewModel)
        viewModel.locationManager!.delegate = viewModel.revisitingLocationDelegate
        viewModel.locationManager!.requestAlwaysAuthorization()
        viewModel.locationManager!.requestWhenInUseAuthorization()
        
        // Snap to Route
        // https://stackoverflow.com/questions/19815248/snap-to-road-for-apple-maps
        // http://regex.info/blog/2016-01-19/2666
        viewModel.locationManager!.activityType = .automotiveNavigation
        
        viewModel.locationManager!.startUpdatingLocation()
        
        return RevisitingLocalizationViewState(viewModel: viewModel)
    }
}

class RecordingLocalizationViewState: LocalizationViewState {
    
    override init(viewModel: LocalizationViewModel) {
        super.init(viewModel: viewModel)
        viewModel.recordingButtonText = "Stop Recording"
        viewModel.recordingButtonDisabled = false
        viewModel.saveButtonDisabled = true
        viewModel.resetButtonDisabled = true
        viewModel.loadSavedPathPickerDisabled = true
        viewModel.revisitingButtonText = "Start Revisting"
        viewModel.revisitingButtonDisabled = true
    }
    
    override func handleRecordButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        viewModel.locationManager!.stopUpdatingLocation()
        viewModel.recordLocationDelegate = nil
        viewModel.locationManager = nil
        return IdleLocalizationViewState(viewModel: viewModel)
    }
}

class RevisitingLocalizationViewState: LocalizationViewState {
    
    override init(viewModel: LocalizationViewModel) {
        super.init(viewModel: viewModel)
        viewModel.recordingButtonText = "Start Recording"
        viewModel.recordingButtonDisabled = true
        viewModel.saveButtonDisabled = true
        viewModel.resetButtonDisabled = true
        viewModel.loadSavedPathPickerDisabled = true
        viewModel.revisitingButtonText = "Stop Revisiting"
        viewModel.revisitingButtonDisabled = false
    }
    
    override func handleRevistingButton(viewModel: LocalizationViewModel) -> LocalizationViewState {
        viewModel.locationManager!.stopUpdatingLocation()
        viewModel.revisitingLocationDelegate = nil
        viewModel.revisitingManager = nil
        viewModel.locationManager = nil
        return IdleLocalizationViewState(viewModel: viewModel)
    }
}

struct LocalizationView: View {
        
    @ObservedObject var viewModel = LocalizationViewModel()
    @State var viewState: LocalizationViewState? = nil
    
    // TODO: Pass ViewModel to LocationDelegate constructor instead of maintaining state in two places
    @State private var selectedTrajectoryPick = ""
    
    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
                Map(coordinateRegion: $viewModel.mostRecentRegion,
                    showsUserLocation: true,
                    annotationItems: viewModel.markers,
                    annotationContent: {
                        annotationItem in
                        annotationItem.getMapAnnotation()
                        // annotationItem.getMarkerIdText()
                        //annotationItem.getMapPin()
                    }
                )
            
                // Text("Region: Lat  \(locationDelegate.mostRecentRegion.center.latitude) Lng : \(locationDelegate.mostRecentRegion.center.longitude)")
                Text(viewModel.mostRecentText)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewState = viewState!.handleRecordButton(viewModel: viewModel)
                    }
                    ) {
                        Text(viewModel.recordingButtonText)
                    }
                        .disabled(viewModel.recordingButtonDisabled)
                    Spacer()
                    Button(action: {
                        viewState = viewState!.handleSaveButton(viewModel: viewModel)
                    }) {
                        Text("Save")
                        
                    }
                        .disabled(viewModel.saveButtonDisabled)
                    Spacer()
                    Button(action: {
                        viewState = viewState!.handleResetButton(viewModel: viewModel)
                    }) {
                        Text("Reset")
                    }
                        .disabled(viewModel.resetButtonDisabled)
                    Spacer()
                }
               
                Picker("Load Saved Path", selection: $selectedTrajectoryPick) {
                    ForEach(viewModel.fileNames, id: \.self) { fileName in
                        Text(fileName)
                    }
                }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 200, height: 50)
                    .disabled(viewModel.loadSavedPathPickerDisabled)
                    .onChange(of: selectedTrajectoryPick, perform: { value in
                        viewState = viewState!.handleLoadSavedPathPick(fileName: selectedTrajectoryPick, viewModel: viewModel)
                    })
                    
                Button(action: {
                    viewState = viewState!.handleRevistingButton(viewModel: viewModel)
                }
                ) {
                    Text(viewModel.revisitingButtonText)
                }
                    .disabled(viewModel.revisitingButtonDisabled)
            } else {
                Text("iOS >= 14.0 required!")
            }
                
        }
        .alert(isPresented: $viewModel.alertShowing, content: {
            Alert(title: Text("GPS Export"), message: Text(viewModel.alertText))
        })
        .onAppear() {
            // TODO: doesn't trigger if view is reloaded without vanshing first (tap twice on same TabBarIcon)
            viewState = IdleLocalizationViewState(viewModel: viewModel)
        }.onDisappear() {
            print("bye bye")
        }
    }


    
}


struct LocalizationView_Previews: PreviewProvider {
    static var previews: some View {
        LocalizationView()
    }
}
