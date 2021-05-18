sub init()
    m.selectList = m.top.findNode("exampleList")
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handle = false
    if press then
        if key = "back" then
            handle = true
            fireEvent("NAVIGATION", { destination: "back" })
        end if
    else if press = false
        if key = "OK" then
            contentType = m.selectList.content.ContentType
            if contentType = 4 then
                'episode type
                itemList = m.selectList.content
            else if contentType = 3 then 
                selectedItem = m.selectList.rowItemSelected
                itemList = m.selectList.content.getChild(selectedItem[0])
            else
                selectedItem = m.selectList.rowItemSelected
                itemList = m.selectList.content.getChild(selectedItem[0]).getChild(selectedItem[1])
                ?"selected Row";selectedItem[0];" selectedColumn: "; selectedItem[1];" selected item: "; itemList.title; " selected item url: "; itemList.url
            endif
            fireEvent("NAVIGATION", { destination: "videoScreen",  selected: itemList })            
        endif        
    endif

    return handle
end function
