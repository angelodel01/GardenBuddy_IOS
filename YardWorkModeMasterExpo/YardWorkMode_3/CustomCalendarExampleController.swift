import UIKit
import CalendarKit
import DateToolsSwift

class CustomCalendarExampleController: DayViewController, DatePickerControllerDelegate, UIViewControllerTransitioningDelegate {
  var currentStyle = SelectedStyle.Light
  
  lazy var customCalendar: Calendar = {
    let customNSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    customNSCalendar.timeZone = TimeZone(abbreviation: "PST")!
    let calendar = customNSCalendar as Calendar
    return calendar
  }()
  
  override func loadView() {
    calendar = customCalendar
    dayView = DayView(calendar: calendar)
    view = dayView
//    dynamoGet()
//    dynamoPut(uid: "11")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CalendarKit Demo"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dark",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(ExampleController.changeStyle))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change Date",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(ExampleController.presentDatePicker))
    navigationController?.navigationBar.isTranslucent = false
    dayView.autoScrollToFirstEvent = true
    reloadData()
  }
  
  @objc func changeStyle() {
    var title: String!
    var style: CalendarStyle!
    
    if currentStyle == .Dark {
      currentStyle = .Light
      title = "Dark"
      style = StyleGenerator.defaultStyle()
    } else {
      title = "Light"
      style = StyleGenerator.darkStyle()
      currentStyle = .Dark
    }
    updateStyle(style)
    navigationItem.rightBarButtonItem!.title = title
    navigationController?.navigationBar.barTintColor = style.header.backgroundColor
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:style.header.swipeLabel.textColor]
    reloadData()
  }
  
  @objc func presentDatePicker() {
    let picker = DatePickerController()
    picker.datePicker.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())!
    picker.delegate = self
    let navC = UINavigationController(rootViewController: picker)
    navigationController?.present(navC, animated: true, completion: nil)
  }
  
  func datePicker(controller: DatePickerController, didSelect date: Date?) {
    if let date = date {
      var utcCalendar = Calendar(identifier: .gregorian)
      utcCalendar.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())!
      
      let offsetDate = dateOnly(date: date, calendar: dayView.calendar)
      
      print(offsetDate)
      dayView.state?.move(to: offsetDate)
    }
    controller.dismiss(animated: true, completion: nil)
  }
  
  func dateOnly(date: Date, calendar: Calendar) -> Date {
    let yearComponent = calendar.component(.year, from: date)
    let monthComponent = calendar.component(.month, from: date)
    let dayComponent = calendar.component(.day, from: date)
    let zone = calendar.timeZone
    
    let newComponents = DateComponents(timeZone: zone,
                                       year: yearComponent,
                                       month: monthComponent,
                                       day: dayComponent)
    let returnValue = calendar.date(from: newComponents)
    
    return returnValue!
  }
  
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
//      dynamoGet()
        if (Schedule.Master != nil){
            let events = Schedule.Master!.translateToDisplay(date)
            return events
        }
//        dynamoGet()
        return [Event]()
    }
    
  private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
  }
  
  // MARK: DayViewDelegate
  
  private var createdEvent: EventDescriptor?
  
  override func dayViewDidSelectEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
  }
  
  override func dayViewDidLongPressEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    endEventEditing()
    print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    beginEditing(event: descriptor, animated: true)
    print(Date())
  }
  
  override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    endEventEditing()
    print("Did Tap at date: \(date)")
  }
  
  override func dayViewDidBeginDragging(dayView: DayView) {
    print("DayView did begin dragging")
  }
  
  override func dayView(dayView: DayView, willMoveTo date: Date) {
    print("DayView = \(dayView) will move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didMoveTo date: Date) {
    print("DayView = \(dayView) did move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    print("Did long press timeline at date \(date)")
    // Cancel editing current event and start creating a new one
    endEventEditing()
    print("Creating a new event")
    makeNewEvent(date: date)
//    Schedule.masterUpdate();
  }
    func cancel(){
        print("cancelled making event")
    }
    
    
    func createNewEvent(sender: AnyObject, date: Date) {
        print("clicked createNewEvent")
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Creating Event", message: "", preferredStyle: .alert)

//        let dialogMessage = UIAlertController(title: "New Room", message: nil, preferredStyle: .alert)
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height:18))
        label.textAlignment = .center
        label.textColor = .red
        label.font = label.font.withSize(12)
        alert.view.addSubview(label)
        label.isHidden = true
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Zone Number"
            textField.keyboardType = .numberPad
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Duration in minutes"
            textField.keyboardType = .numberPad
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let zone_num = alert?.textFields![0] // Force unwrapping because we know it exists.
            let duration = alert?.textFields![1] // Force unwrapping because we know it exists.
            if ((zone_num!.text == "") || (duration!.text == "")){
                return;
            }
            let zn = Int(zone_num!.text!)!
            let d = Int(duration!.text!)!
            if ( zn > 12 || zn < 0){
                label.text = ""
                label.text = "Invalid zone number"
                label.isHidden = false
                self.present(alert!, animated: true, completion: nil)
            } else if (d > 1440){
                label.text = ""
                label.text = "Duration more than a day"
                label.isHidden = false
                self.present(alert!, animated: true, completion: nil)
            } else{
                let g_event:GB_Event = GB_Event(
                    zone_num: Int(zone_num!.text!) ?? 0,
                    trigger_type: TRIGGER_TYPE.MID,
                    time_offset : 0,
                    duration : Int(duration!.text!)!*60,
                    mods : [])
                g_event.time_offset = GB_Event.getMidNightOffset(date: date);
                Schedule.Master!.addGBEvent(new: g_event, date: date)
                self.reloadData()
            }


        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func makeNewEvent(date: Date){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)


        alert.addAction(UIAlertAction(title: "Create New Event", style: .default) { _ in
            self.createNewEvent(sender: self, date: date)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            self.cancel()
        })

        present(alert, animated: true)
    }

  
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
    
    if let _ = event.editedEvent {
      event.commitEditing()
      Schedule.updateEvent(startDate:event.startDate, endDate: event.endDate, eventInfo: event as! Event)
      endEventEditing()
      print("commitEditing()")
    }
    
    if let createdEvent = createdEvent {
      createdEvent.editedEvent = nil
      self.createdEvent = nil
      endEventEditing()
      print("endEventEditing()")
    }
    print("did finish editing \(event)")
//    dynamoPut(uid: "100")
    reloadData()
  }
}
