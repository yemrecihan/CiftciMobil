

import UIKit
import MapKit

class AddFieldPage: UIViewController ,UITextFieldDelegate{
    var cityNetwor = CityNetwork()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var districtTextField: UITextField!
    
    var viewModel = AddFieldPageViewModel()
    private var cityPickerView = UIPickerView()
      private var districtPickerView = UIPickerView()
      private var neighborhoodPickerView = UIPickerView()
    
    @IBOutlet weak var neighborhoodTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        setupPickerViews()
        
      
        
        // Şehirler yüklendiğinde veriyi al ve PickerView'ı yenile
        viewModel.didUpdateCities = { [weak self] in
            DispatchQueue.main.async {
                self?.cityPickerView.reloadAllComponents()
            }
        }
        // Şehir verilerini yükleme
        viewModel.loadCities()   
      
        viewModel.coordinate = { [weak self] coordinate in
                self?.updateMapView(with: coordinate)
            }
        
    }
    private func setupTextFields() {
           cityTextField.delegate = self
           districtTextField.delegate = self
           neighborhoodTextField.delegate = self

           cityTextField.inputView = cityPickerView
           districtTextField.inputView = districtPickerView
           neighborhoodTextField.inputView = neighborhoodPickerView
       }
    private func setupPickerViews() {
           cityPickerView.delegate = self
           cityPickerView.dataSource = self
           districtPickerView.delegate = self
           districtPickerView.dataSource = self
           neighborhoodPickerView.delegate = self
           neighborhoodPickerView.dataSource = self
       }
    func textFieldDidEndEditing(_ textField: UITextField) {
          viewModel.updateLocation(
              for: cityTextField.text ?? "",
              district: districtTextField.text ?? "",
              neighborhood: neighborhoodTextField.text ?? ""
          )
      }
    
    
      
        
        private func updateMapView(with coordinate: CLLocationCoordinate2D) {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    
    @IBAction func resetButton(_ sender: Any) {
        cityTextField.text = ""
        districtTextField.text = ""
        neighborhoodTextField.text = ""
        viewModel.clearSelections()
    }

}
extension AddFieldPage:UIPickerViewDelegate , UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == cityPickerView {
                return viewModel.getCityNames().count
            } else if pickerView == districtPickerView {
                return viewModel.getCountyNames(forCity: cityTextField.text ?? "").count
            } else {
                return viewModel.getNeighborhoodNames(forCity: cityTextField.text ?? "", county: districtTextField.text ?? "").count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == cityPickerView {
                return viewModel.getCityNames()[row]
            } else if pickerView == districtPickerView {
                return viewModel.getCountyNames(forCity: cityTextField.text ?? "")[row]
            } else {
                return viewModel.getNeighborhoodNames(forCity: cityTextField.text ?? "", county: districtTextField.text ?? "")[row]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == cityPickerView {
                cityTextField.text = viewModel.getCityNames()[row]
                districtTextField.text = ""
                neighborhoodTextField.text = ""
                districtPickerView.reloadAllComponents()
                neighborhoodPickerView.reloadAllComponents() 
                //Şehir seçimi sonrası PickerView ı kapat -->>
                cityTextField.resignFirstResponder()
            } else if pickerView == districtPickerView {
                districtTextField.text = viewModel.getCountyNames(forCity: cityTextField.text ?? "")[row]
                neighborhoodTextField.text = ""
                neighborhoodPickerView.reloadAllComponents()
                
                districtTextField.resignFirstResponder()
            } else {
                neighborhoodTextField.text = viewModel.getNeighborhoodNames(forCity: cityTextField.text ?? "", county: districtTextField.text ?? "")[row]
                
                neighborhoodTextField.resignFirstResponder()
            }
        }
}
