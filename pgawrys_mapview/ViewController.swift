import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var textField: UILabel!
    
    var myLocationManager: CLLocationManager!
    
    
    @IBAction func startButtonAction(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        
        myLocationManager.startUpdatingLocation()
        mapViewOutlet.showsUserLocation = true
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        
        myLocationManager.stopUpdatingLocation()
        mapViewOutlet.showsUserLocation = false
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        mapViewOutlet.removeAnnotations(mapViewOutlet.annotations)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initButtons()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        clearButton.isEnabled = true
        textField.text = ""
        
        if (CLLocationManager.locationServicesEnabled())
        {
            myLocationManager = CLLocationManager()
            myLocationManager.delegate = self
            myLocationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
    
        let marker = MKPointAnnotation()
        marker.coordinate = lastLocation.coordinate
        mapViewOutlet.addAnnotation(marker)
    
        let delta = abs(lastLocation.speed / 4000)
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: lastLocation.coordinate, span: span)
        
        mapViewOutlet.setRegion(region, animated: true)

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(lastLocation) { (placemark, _) in
            let firstPlacemark = placemark?.first
            
            var address = (firstPlacemark?.name ?? "") + ", "
            address += (firstPlacemark?.locality ?? "") + ", "
            address += (firstPlacemark?.country ?? "")
            
            self.textField.text = address
        }
    }

}
