// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function set_youtube_embedded_code() {

    var youtube_url = document.getElementById('media_url').value;
    var code = extract_youtube_video_code(youtube_url);

    if (code != '') {
        document.getElementById('video_preview').innerHTML = generate_youtube_embedded_code(code);
    }

    return '';
}

function extract_youtube_video_code(youtube_url) {

    if (youtube_url.match(/http:\/\/www\.youtube\.com\/watch\?v\=(.+)/)) {
        return RegExp.$1;
    }

    return '';
}

function generate_youtube_embedded_code(video_id) {
  return '<object width="480" height="385"> ' +
	 ' <param name="movie" value="http://www.youtube.com/v/' + video_id + '&hl=en_US&fs=1&rel=0"></param><param name="allowFullScreen" value="true"></param> ' +
	 ' <param name="allowscriptaccess" value="always"></param> ' +
	 ' <embed src="http://www.youtube.com/v/' + video_id + '&hl=en_US&fs=1&rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed> ' +
	 '</object>';
}