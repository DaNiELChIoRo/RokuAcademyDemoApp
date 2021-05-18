sub fireEvent(evtType as String, evtData as object)
    event = {"type": evtType, "data": evtData}
    queue = m.global.eventQueue
    queue.push(event)
    m.global.eventQueue = queue
    ' time = CreateObject("roDateTime")

end sub