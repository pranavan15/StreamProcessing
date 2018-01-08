package fileStream;

import ballerina.net.http;
import ballerina.file;
import ballerina.io;

file:File directory = {path:"/home/pranavan/IdeaProjects/StreamProcessing/fileStream/util"};

@http:configuration {basePath:"/lyricsService"}
service<http> lyricsService {

    @http:resourceConfig {
        methods:["GET"],
        path:"/getAvailableSongs"
    }
    resource getAvailableSongs (http:Request req, http:Response res) {
        json[] filesList = getFileNames();
        res.setJsonPayload(filesList);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/getSongLyrics/{songName}"
    }
    resource getSongLyrics (http:Request req, http:Response res, string songName) {
        blob lyricsBlob = getLyrics(songName);
        string lyrics = lyricsBlob.toString("UTF-8");
        res.setJsonPayload(lyrics);
        _ = res.send();
    }
}

function getFileNames()(json[] fileNames) {
    var filesList, _, _ = directory.list();
    int i = 0;
    json[] files = [];
    while (i < lengthof filesList) {
        var filePath, _ = <json>filesList[i];
        string file = filePath.toString();
        file = file.replace("{\"path\":\"/home/pranavan/IdeaProjects/StreamProcessing/fileStream/util/", "");
        file = file.replace(".txt\"}", "");
        files[i] = file;
        i = i + 1;
    }
    return  files;
}

function getLyrics(string songName)(blob lyrics) {
    string filePath = "/home/pranavan/IdeaProjects/StreamProcessing/fileStream/util/" + songName + ".txt";
    io:ByteChannel channel = getFileChannel(filePath, "r");
    var readContent, numOfBytesRead = readBytes(channel);
    return readContent;
}

function getFileChannel (string filePath, string permission) (io:ByteChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    return channel;
}

function readBytes (io:ByteChannel channel) (blob, int) {
    blob readContent;
    int numberOfBytesRead;
    readContent,numberOfBytesRead = channel.readAllBytes();
    return readContent, numberOfBytesRead;
}
