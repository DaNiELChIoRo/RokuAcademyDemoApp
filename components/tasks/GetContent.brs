sub init()
    m.top.functionName =  "getContent"
end sub

sub getContent()
     transfer = CreateObject("roUrlTransfer")
     port = CreateObject("roMessagePort")
     transfer.setMessagePort(port)
     transfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
     transfer.setUrl(m.top.contentUrl)
     if transfer.asyncGetToString()
        msg = port.waitMessage(0)
        if type(msg) = "roUrlEvent"
            code = msg.getResponseCode()
            if code = 200
                    contentAA = parseJson(msg.getString())
                    contentNode = parseFeed(contentAA)
                    m.top.content = contentNode
            end if
        endif
    endif
end sub

function parseFeed(contentAA)
    feedNode = CreateObject("roSGNode", "ContentNode")
    movieRow = feedNode.CreateChild("ContentNode")
    movieRow.title = "Movies"
    seriesRow = feedNode.CreateChild("ContentNode")
    seriesRow.title = "Series"
    shortsRow = feedNode.CreateChild("ContentNode")
    shortsRow.title =  "ShortRows"

    for x = 0 to contentAA.movies.count() - 1
        movie = contentAA.movies[x]
        movieNode = movieRow.CreateChild("ContentNode")
        movieNode.title = movie.title
        movieNode.HDPosterUrl = movie.thumbnail
        movieNode.url = movie.content.videos[0].url
    end for

    ' Series
    for x = 0 to contentAA.series.count() - 1
        series = contentAA.series[x]
        seriesNode = seriesRow.CreateChild("ContentNode")
        seriesNode.title = series.title
        seriesNode.HDPosterUrl = series.thumbnail
        seriesNode.ContentType = "series"
        'Seasons
        for y = 0 to series.seasons.count() - 1
            season = series.seasons[y]
            seasonNode = seriesNode.CreateChild("ContentNode")
            seasonNode.title = season.title           
            seasonNode.ContentType = "season"
            'Episodes
            for z = 0 to season.episodes.count() - 1
                episode = season.episodes[z]
                episodeNode = seasonNode.CreateChild("ContentNode")
                episodeNode.title = episode.title
                ?"season ";season.title; " episode ";episode.title; " episode image: "; episode.thumbnail
                episodeNode.HDPosterUrl = episode.thumbnail
                episodeNode.url = episode.content.videos[0].url
                episodeNode.Description = episode.longDescription
                episodeNode.ContentType = "episode"
            end for     
        end for
    end for

    for x = 0 to contentAA.shortFormVideos.count() - 1
        shorts = contentAA.shortFormVideos[x]
        shortsNode = shortsRow.CreateChild("ContentNode")
        shortsNode.title = shorts.title
        shortsNode.HDPosterUrl = shorts.thumbnail
    end for
    return feedNode
end function
