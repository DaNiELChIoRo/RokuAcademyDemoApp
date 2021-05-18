sub init()
    m.imageHolder = m.top.findNode("imageHolder")  
    m.titleHolder = m.top.findNode("titleHolder")  
end sub



sub setContent()
  itemContent = m.top.itemContent
  m.imageHolder.uri = itemContent.HDPosterUrl
  m.titleHolder.text = itemContent.title
end sub