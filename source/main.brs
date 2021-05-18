sub main(args as dynamic)
    showHomeScreen()
end sub

sub showHomeScreen()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    rokuAppIngo = CreateObject("roAppInfo")
    appVersion = rokuAppIngo.getVersion()

    screen.setMessagePort(m.port)
    m.scene = screen.CreateScene("RootScene")
    screen.show()
    
    while(true)
        msg = wait(100, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub