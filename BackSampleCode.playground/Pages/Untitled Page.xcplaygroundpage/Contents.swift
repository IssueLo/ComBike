let formatter = DateFormatter()

formatter.dateFormat = "yyyy/MM/dd HH:mm"

let date = Date()

let dateString = formatter.string(from: date)
