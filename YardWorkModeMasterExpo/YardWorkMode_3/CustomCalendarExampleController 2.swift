import UIKit
import CalendarKit
import DateToolsSwift

class CustomCalendarExampleController: DayViewController, DatePickerControllerDelegate {
  var currentStyle = SelectedStyle.Light
  
  lazy var customCalendar: Calendar = {
    let customNSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    customNSCalendar.timeZone = TimeZone(abbreviation: "CEST")!
    let calendar = customNSCalendar as Calendar
    return calendar
  }()
  
  override func loadView() {
    calendar = customCalendar
    dayView = DayView(calendar: calendar)
    view = dayView
    dynamoGet()
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
    //    let calendar = dayView.calendar
    //    picker.calendar = calendar
    //    picker.date = dayView.state!.selectedDate
    picker.datePicker.timeZone = TimeZone(secondsFromGMT: 0)!
    picker.delegate = self
    let navC = UINavigationController(rootViewController: picker)
    navigationController?.present(navC, animated: true, completion: nil)
  }
  
  func datePicker(controller: DatePickerController, didSelect date: Date?) {
    if let date = date {
      var utcCalendar = Calendar(identifier: .gregorian)
      utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
      
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
        if (Schedule.Master != nil){
            let events = Schedule.Master!.translateToDisplay(date)
            return events
        }
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
  }

  
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
    
    if let _ = event.editedEvent {
      event.commitEditing()
        Schedule.updateEvent(startDate:event.startDate, endDate: event.endDate, eventInfo: event as! Event)
      print("commitEditing()")
    }
    
    if let createdEvent = createdEvent {
      createdEvent.editedEvent = nil
      self.createdEvent = nil
      endEventEditing()
      print("endEventEditing()")
    }
    print("did finish editing \(event)")
    reloadData()
  }
}
