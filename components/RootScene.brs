sub init()
    m.selectScreen = CreateObject("roSGNode", "SelectScreen")
    m.top.appendChild(m.selectScreen)

    m.seasionselectScreen = CreateObject("roSGNode", "SelectScreen")
    m.top.appendChild(m.seasionselectScreen)
    m.seasionselectScreen.visible = false

    m.detailScreen = CreateObject("roSGNode", "DetailScreen")
    m.top.appendChild(m.detailScreen)
    m.detailScreen.visible = false
    ?"detailScreen: "; m.detailScreen
    
    m.contentTask = CreateObject("roSGNode", "GetContent")
    m.contentTask.contentUrl = "https://jonathanbduval.com/roku/feeds/roku-developers-feed-v1.json"
    m.contentTask.observeField("content", "handleContent")
    m.contentTask.control = "RUN"

    m.videoScreen = CreateObject("roSGNode", "VideoScreen")
    m.top.appendChild(m.videoScreen)
    m.videoScreen.visible = false

    m.global.addFields({
        eventQueue:[]
    })
    m.global.observeField("eventQueue", "handleEventQueue")
end sub

sub handleContent()
    m.exampleRowList = m.selectScreen.findNode("exampleList")
    rowContent = m.contentTask.content
    ?"ROW LIST CONTENT: "; rowContent
    m.exampleRowList.content = rowContent
    m.exampleRowList.setFocus(true)
end sub

sub handleEventQueue()
    queue = m.global.eventQueue
    if queue.count() > 0
        handleEvent(queue.pop())    
        m.global.eventQueue = queue
    endif

    if queue.count() > 0
        handleEventQueue()
    endif
end sub

sub handleEvent(evt as object)    
    ?"Event: "; evt.type; ": "; evt.data   
    if evt.type = "TIME_EVENT"
        ' ?"label: "; m.label
        m.label.text = evt.data.time
    else if evt.type = "NAVIGATION"
        handleNavigation(evt.data)
    endif 
end sub

sub handleNavigation(navigationData as object)
    if navigationData.destination = "videoScreen" then
        m.selectScreen.visible = false
        ' Handling the series node case!
        if navigationData.selected.ContentType = 2 OR navigationData.selected.ContentType = 3 then
            m.seasionselectScreen.visible = true
            
            m.rowList = m.seasionselectScreen.findNode("exampleList")
            m.rowList.content = navigationData.selected
            m.rowList.setFocus(true)
        else if navigationData.selected.ContentType = 4 then
            m.seasionselectScreen.visible = false
            m.detailScreen.visible = true
            'Passing the Video Attributes to DetailScreen
            m.detailScreen.videoNode = navigationData.selected
            m.detailScreen.setFocus(true)
        else    
            m.videoScreen.visible = true
            m.videoScreen.videoUrl = navigationData.selected.url            
            m.videoScreen.setFocus(true)
        end if
    else if navigationData.destination = "video" then
        m.detailScreen.visible = false
        m.videoScreen.visible = true                
        m.videoScreen.videoUrl = navigationData.selected.url            
        m.videoScreen.setFocus(true)
    else if navigationData.destination = "back" then
        if m.videoScreen.visible then
            m.videoScreen.visible = false
            m.rowList.setFocus(true)
        else if m.detailScreen.visible then
            m.detailScreen.visible = false
            m.seasionselectScreen.visible = true
            m.rowList.setFocus(true)
        else if m.seasionselectScreen.visible then
            m.seasionselectScreen.visible = false
            m.selectScreen.visible = true
            m.exampleRowList.setFocus(true)
        end if
    end if
end sub