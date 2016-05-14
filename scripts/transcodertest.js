var ffmpeg = require('ffmpeg');
var fs = require('fs');
var ipfsAPI = require('ipfs-api')

var ipfsnode = '/ip4/localhost/tcp/5001';

function transcode(filename,cb) {
    try {

        var out_filename = filename + '-360.avi';

        if (fs.existsSync(out_filename)){
            console.log('deleting file',out_filename);
            fs.unlinkSync(out_filename);
        }

        var process = new ffmpeg(filename);
        process.then(function(video) {
            console.log('starting transcoding of file ',filename);
            console.log(video.metadata);
            video
//                .setVideoSize('?x480', true, false)
                .setVideoSize('?x360', true, false)
                .setVideoDuration(10)
//                .setAudioCodec('libfaac')
//                .setVideoCodec('mpeg4')
//                .setVideoFormat('avi')
//                .setVideoBitRate(1024)
                //        .setAudioCodec('flv1')
                //        .setAudioChannels(2)
                .save(out_filename, function(error, file) {
                    if (error) {
                        console.log(error);
                    }
                    if (!error) {
                        console.log('saved transcoded file:',file);
                        if (cb) cb();
                    }
                });

        }, function(err) {
            console.log('Error: ' + err);
        });
    } catch (e) {
        console.log(e.code);
        console.log(e.msg);
    }
}

transcode('a.avi',function(){
//    upload('./c.mp4');
});

function upload(filename) {
    var filestream = fs.createReadStream(filename, {
        bufferSize: 128
    })
    var ipfs = ipfsAPI(ipfsnode);
    ipfs.add(filestream, (err, res) => {
        if (err) {
            console.log(err);
        } else {
            console.log(res);
            var videohash = res[0].Hash;


            var video_metaobject = {
                title: "Test Video",
                description: "Description of the test video",
                hash: videohash,
                created: Math.floor(Date.now() / 1000)
            }
            console.log(video_metaobject);

            ipfs.add(new Buffer(JSON.stringify(video_metaobject)), (err, res) => {
                if (err) {
                    console.log(err);
                } else {
                    console.log('video metadata object is at ', res[0].Hash);
                }


            });

        }
    });

}