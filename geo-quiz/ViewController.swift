//
//  ViewController.swift
//  geo-quiz
//
//  Created by stefan on 12/16/16.
//  Copyright © 2016 stefan. All rights reserved.
//

import UIKit
import MapKit
import Foundation

let DEBUG = 0

class ViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mMap: MKMapView!
  var segueQuiz: Quiz? = nil
  var capitals = [String:Capital]()
  var flag: Bool = false
  var currentAnnotation: MKAnnotation? = nil
  var currScore: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    mMap.delegate = self
    self.loadCapitalsToMap()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func loadCapitalsToMap()->Void{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    capitals = appDelegate.unAnsweredCapitals
    //print(appDelegate.unAnsweredCapitals.count)
    //print("Capital count = ")
    //print(capitals.count)
    
    self.mMap.addAnnotations(Array(capitals.values))
  } // END METHOD loadCapitalsToMap
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // 1
    let identifier = "Capital"
    
    // 2
    if annotation is Capital {
      // 3
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      
      if annotationView == nil {
        //4
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = true
        
        // 5
        let btn = UIButton(type: .detailDisclosure)
        annotationView!.rightCalloutAccessoryView = btn
      } else {
        // 6
        annotationView!.annotation = annotation
      }
      
      return annotationView
    }
    
    // 7
    return nil
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //let capital = view.annotation as! Capital
    //let placeName = capital.title
    //let placeInfo = capital.info
    
    //let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
    //ac.addAction(UIAlertAction(title: "OK", style: .default))
    //present(ac, animated: true)
    self.currentAnnotation = view.annotation
    if self.segueQuiz == nil{
      let tNation = (view.annotation!.title)!
      self.segueQuiz = Quiz(
        nat: tNation!, 
        cor: ((self.capitals[tNation!])!).capital!, 
        opt: self.getOptions(currNat: tNation!)
      )
    }
    else{
      self.segueQuiz?.nation = (view.annotation!.title)!
      self.segueQuiz?.correct = ((self.capitals[(self.segueQuiz?.nation)!])!).capital! 
      self.segueQuiz?.options = self.getOptions(currNat: (self.segueQuiz?.nation)!) 
    }
    
    performSegue(withIdentifier: "showQuizSegue", sender: view)
  } // END mapView METHOD
  
  
  // PREPARE FOR SEGUE
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showQuizSegue"{
      if let destination = segue.destination as? QuizTableViewController {
        //destination.selectedQuiz = Quiz(nat: "ROC", cor: "Taipei", opt: ["A", "B", "C", "D"])
        destination.selectedQuiz = self.segueQuiz
        destination.currScore = self.currScore
      }
    }
  }
  
  // Unwind Segue (from Quiz table)
  @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    //print("unwindToMenu called")
    if self.flag == true{
      mMap.removeAnnotation(self.currentAnnotation!)
      // TODO: update disctionary here
      /*
      // CHECK WIN
      if self.currScore == self.capitals.count{
        let rAlert = UIAlertController(
          title: "Result", 
          message: "You win !!! You have \(self.currScore) points.", 
          preferredStyle: UIAlertControllerStyle.alert)
        
        rAlert.addAction(UIAlertAction(
          title: "Ok", style: .default, 
          handler: { 
            (action: UIAlertAction!) in
            UIControl().sendAction(
              #selector(URLSessionTask.suspend), 
              to: UIApplication.shared, 
              for: nil
            )
        }))
        present(rAlert, animated: true, completion: nil)
      } // END IF
      */
    }
    self.flag = false
  }
  
  // GENERATE RANDOM OPTIONS
  func getOptions(currNat: String) -> [String] {
    var retArr = [String]()
    let temp = Array(self.capitals.values)
    retArr.append((self.capitals[currNat]?.capital)!)
    var i: Int = 0
    while i < 3 {
      let index: Int = Int(arc4random_uniform(UInt32(self.capitals.count)))
      if currNat != temp[index].title{
        i += 1
        retArr.append(temp[index].capital!)
      }
    }
    
    if retArr.count == 4{
      retArr.shuffle()
      return retArr
    }
    return ["A", "B", "C", "D"]
  }
} // END CLASS

extension MutableCollection where Indices.Iterator.Element == Index {
  /// Shuffles the contents of this collection.
  mutating func shuffle() {
    let c = count
    guard c > 1 else { return }
    
    for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
      let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
      guard d != 0 else { continue }
      let i = index(firstUnshuffled, offsetBy: d)
      swap(&self[firstUnshuffled], &self[i])
    }
  }
}

extension Sequence {
  /// Returns an array with the contents of this sequence, shuffled.
  func shuffled() -> [Iterator.Element] {
    var result = Array(self)
    result.shuffle()
    return result
  }
}
/**
 Afghanistan,Kabul,34.28N,69.11E
 Albania,Tirane,41.18N,19.49E
 Algeria,Algiers,36.42N,03.08E
 American Samoa,Pago Pago,14.16S,170.43W
 Andorra,Andorra la Vella,42.31N,01.32E
 Angola,Luanda,08.50S,13.15E
 Antigua and Barbuda,West Indies,17.20N,61.48W
 Argentina,Buenos Aires,36.30S,60.00W
 Armenia,Yerevan,40.10N,44.31E
 Aruba,Oranjestad,12.32N,70.02W
 Australia,Canberra,35.15S,149.08E
 Austria,Vienna,48.12N,16.22E
 Azerbaijan,Baku,40.29N,49.56E
 Bahamas,Nassau,25.05N,77.20W
 Bahrain,Manama,26.10N,50.30E
 Bangladesh,Dhaka,23.43N,90.26E
 Barbados,Bridgetown,13.05N,59.30W
 Belarus,Minsk,53.52N,27.30E
 Belgium,Brussels,50.51N,04.21E
 Belize,Belmopan,17.18N,88.30W
 Benin,Porto Novo (constitutional) / Cotonou (seat of government),06.23N,02.42E
 Bhutan,Thimphu,27.31N,89.45E
 Bolivia,La Paz (administrative) / Sucre (legislative),16.20S,68.10W
 Bosnia and Herzegovina,Sarajevo,43.52N,18.26E
 Botswana,Gaborone,24.45S,25.57E
 Brazil,Brasilia,15.47S,47.55W
 British Virgin Islands,Road Town,18.27N,64.37W
 Brunei Darussalam,Bandar Seri Begawan,04.52N,115.00E
 Bulgaria,Sofia,42.45N,23.20E
 Burkina Faso,Ouagadougou,12.15N,01.30W
 Burundi,Bujumbura,03.16S,29.18E
 Cambodia,Phnom Penh,11.33N,104.55E
 Cameroon,Yaounde,03.50N,11.35E
 Canada,Ottawa,45.27N,75.42W
 Cape Verde,Praia,15.02N,23.34W
 Cayman Islands,George Town,19.20N,81.24W
 Central African Republic,Bangui,04.23N,18.35E
 Chad,N'Djamena,12.10N,14.59E
 Chile,Santiago,33.24S,70.40W
 China,Beijing,39.55N,116.20E
 Colombia,Bogota,04.34N,74.00W
 Comros,Moroni,11.40S,43.16E
 Congo,Brazzaville,04.09S,15.12E
 Costa Rica,San Jose,09.55N,84.02W
 Cote d'Ivoire,Yamoussoukro,06.49N,05.17W
 Croatia,Zagreb,45.50N,15.58E
 Cuba,Havana,23.08N,82.22W
 Cyprus,Nicosia,35.10N,33.25E
 Czech Republic,Prague,50.05N,14.22E
 Democratic Republic of the Congo,Kinshasa,04.20S,15.15E
 Denmark,Copenhagen,55.41N,12.34E
 Djibouti,Djibouti,11.08N,42.20E
 Dominica,Roseau,15.20N,61.24W
 Dominica Republic,Santo Domingo,18.30N,69.59W
 East Timor,Dili,08.29S,125.34E
 Ecuador,Quito,00.15S,78.35W
 Egypt,Cairo,30.01N,31.14E
 El Salvador,San Salvador,13.40N,89.10W
 Equatorial Guinea,Malabo,03.45N,08.50E
 Eritrea,Asmara,15.19N,38.55E
 Estonia,Tallinn,59.22N,24.48E
 Ethiopia,Addis Ababa,09.02N,38.42E
 Falkland Islands (Malvinas),Stanley,51.40S,59.51W
 Faroe Islands,Torshavn,62.05N,06.56W
 Fiji,Suva,18.06S,178.30E
 Finland,Helsinki,60.15N,25.03E
 France,Paris,48.50N,02.20E
 French Guiana,Cayenne,05.05N,52.18W
 French Polynesia,Papeete,17.32S,149.34W
 Gabon,Libreville,00.25N,09.26E
 Gambia,Banjul,13.28N,16.40W
 Georgia,T'bilisi,41.43N,44.50E
 Germany,Berlin,52.30N,13.25E
 Ghana,Accra,05.35N,00.06W
 Greece,Athens,37.58N,23.46E
 Greenland,Nuuk,64.10N,51.35W
 Guadeloupe,Basse-Terre,16.00N,61.44W
 Guatemala,Guatemala,14.40N,90.22W
 Guernsey,St. Peter Port,49.26N,02.33W
 Guinea,Conakry,09.29N,13.49W
 Guinea-Bissau,Bissau,11.45N,15.45W
 Guyana,Georgetown,06.50N,58.12W
 Haiti,Port-au-Prince,18.40N,72.20W
 Honduras,Tegucigalpa,14.05N,87.14W
 Hungary,Budapest,47.29N,19.05E
 Iceland,Reykjavik,64.10N,21.57W
 India,New Delhi,28.37N,77.13E
 Indonesia,Jakarta,06.09S,106.49E
 Iran (Islamic Republic of),Tehran,35.44N,51.30E
 Iraq,Baghdad,33.20N,44.30E
 Ireland,Dublin,53.21N,06.15W
 Israel,Jerusalem,31.71N,35.10E
 Italy,Rome,41.54N,12.29E
 Jamaica,Kingston,18.00N,76.50W
 Jordan,Amman,31.57N,35.52E
 Kazakhstan,Astana,51.10N,71.30E
 Kenya,Nairobi,01.17S,36.48E
 Kiribati,Tarawa,01.30N,173.00E
 Kuwait,Kuwait,29.30N,48.00E
 Kyrgyzstan,Bishkek,42.54N,74.46E
 Lao People's Democratic Republic,Vientiane,17.58N,102.36E
 Latvia,Riga,56.53N,24.08E
 Lebanon,Beirut,33.53N,35.31E
 Lesotho,Maseru,29.18S,27.30E
 Liberia,Monrovia,06.18N,10.47W
 Libyan Arab Jamahiriya,Tripoli,32.49N,13.07E
 Liechtenstein,Vaduz,47.08N,09.31E
 Lithuania,Vilnius,54.38N,25.19E
 Luxembourg,Luxembourg,49.37N,06.09E
 Macao, China,Macau,22.12N,113.33E
 Madagascar,Antananarivo,18.55S,47.31E
 Macedonia (Former Yugoslav Republic),Skopje,42.01N,21.26E
 Malawi,Lilongwe,14.00S,33.48E
 Malaysia,Kuala Lumpur,03.09N,101.41E
 Maldives,Male,04.00N,73.28E
 Mali,Bamako,12.34N,07.55W
 Malta,Valletta,35.54N,14.31E
 Martinique,Fort-de-France,14.36N,61.02W
 Mauritania,Nouakchott,20.10S,57.30E
 Mayotte,Mamoudzou,12.48S,45.14E
 Mexico,Mexico,19.20N,99.10W
 Micronesia (Federated States of),Palikir,06.55N,158.09E
 Moldova, Republic of,Chisinau,47.02N,28.50E
 Mozambique,Maputo,25.58S,32.32E
 Myanmar,Yangon,16.45N,96.20E
 Namibia,Windhoek,22.35S,17.04E
 Nepal,Kathmandu,27.45N,85.20E
 Netherlands,Amsterdam / The Hague (seat of Government),52.23N,04.54E
 Netherlands Antilles,Willemstad,12.05N,69.00W
 New Caledonia,Noumea,22.17S,166.30E
 New Zealand,Wellington,41.19S,174.46E
 Nicaragua,Managua,12.06N,86.20W
 Niger,Niamey,13.27N,02.06E
 Nigeria,Abuja,09.05N,07.32E
 Norfolk Island,Kingston,45.20S,168.43E
 North Korea,Pyongyang,39.09N,125.30E
 Northern Mariana Islands,Saipan,15.12N,145.45E
 Norway,Oslo,59.55N,10.45E
 Oman,Masqat,23.37N,58.36E
 Pakistan,Islamabad,33.40N,73.10E
 Palau,Koror,07.20N,134.28E
 Panama,Panama,09.00N,79.25W
 Papua New Guinea,Port Moresby,09.24S,147.08E
 Paraguay,Asuncion,25.10S,57.30W
 Peru,Lima,12.00S,77.00W
 Philippines,Manila,14.40N,121.03E
 Poland,Warsaw,52.13N,21.00E
 Portugal,Lisbon,38.42N,09.10W
 Puerto Rico,San Juan,18.28N,66.07W
 Qatar,Doha,25.15N,51.35E
 Republic of Korea,Seoul,37.31N,126.58E
 Romania,Bucuresti,44.27N,26.10E
 Russian Federation,Moskva,55.45N,37.35E
 Rawanda,Kigali,01.59S,30.04E
 Saint Kitts and Nevis,Basseterre,17.17N,62.43W
 Saint Lucia,Castries,14.02N,60.58W
 Saint Pierre and Miquelon,Saint-Pierre,46.46N,56.12W
 Saint Vincent and the Greenadines,Kingstown,13.10N,61.10W
 Samoa,Apia,13.50S,171.50W
 San Marino,San Marino,43.55N,12.30E
 Sao Tome and Principe,Sao Tome,00.10N,06.39E
 Saudi Arabia,Riyadh,24.41N,46.42E
 Senegal,Dakar,14.34N,17.29W
 Sierra Leone,Freetown,08.30N,13.17W
 Slovakia,Bratislava,48.10N,17.07E
 Slovenia,Ljubljana,46.04N,14.33E
 Solomon Islands,Honiara,09.27S,159.57E
 Somalia,Mogadishu,02.02N,45.25E
 South Africa,Pretoria (administrative) / Cape Town (legislative) / Bloemfontein (judicial),25.44S,28.12E
 Spain,Madrid,40.25N,03.45W
 Sudan,Khartoum,15.31N,32.35E
 Suriname,Paramaribo,05.50N,55.10W
 Swaziland,Mbabane (administrative),26.18S,31.06E
 Sweden,Stockholm,59.20N,18.03E
 Switzerland,Bern,46.57N,07.28E
 Syrian Arab Republic,Damascus,33.30N,36.18E
 Tajikistan,Dushanbe,38.33N,68.48E
 Thailand,Bangkok,13.45N,100.35E
 Togo,Lome,06.09N,01.20E
 Tonga,Nuku'alofa,21.10S,174.00W
 Tunisia,Tunis,36.50N,10.11E
 Turkey,Ankara,39.57N,32.54E
 Turkmenistan,Ashgabat,38.00N,57.50E
 Tuvalu,Funafuti,08.31S,179.13E
 Uganda,Kampala,00.20N,32.30E
 Ukraine,Kiev (Russia),50.30N,30.28E
 United Arab Emirates,Abu Dhabi,24.28N,54.22E
 United Kingdom of Great Britain and Northern Ireland,London,51.36N,00.05W
 United Republic of Tanzania,Dodoma,06.08S,35.45E
 United States of America,Washington DC,39.91N,77.02W
 United States of Virgin Islands,Charlotte Amalie,18.21N,64.56W
 Uruguay,Montevideo,34.50S,56.11W
 Uzbekistan,Tashkent,41.20N,69.10E
 Vanuatu,Port-Vila,17.45S,168.18E
 Venezuela,Caracas,10.30N,66.55W
 Viet Nam,Hanoi,21.05N,105.55E
 Yugoslavia,Belgrade,44.50N,20.37E
 Zambia,Lusaka,15.28S,28.16E
 Zimbabwe,Harare,17.43S,31.02E
 */