sub init()
    m.top.functionName = "getContent"
    ?"Initializing GetTime"

    ?"global from GetTime: "; m.global
    m.global.ObserveField("eventQueue", "handleEventQueue")
end sub

sub getContent()
    readInternet = CreateObject("roUrlTransfer")
    readInternet.setUrl(m.top.contentUri)
    contentStr = readInternet.GetToString()    
    contentArray = ParseJson(contentStr)    

    m.top.content = contentArray
end sub

sub handleEventQueue()
    queue = m.global.eventQueue
    if queue.count() > 0
        handleEvent(queue.pop())    
        ' m.global.eventQueue = queue
    endif

    if queue.count() > 0
        handleEventQueue()
    endif
end sub

sub handleEvent(evt as object)    
    ?"Event from GETTIME: "; evt.type; ": "; evt.data       
end sub