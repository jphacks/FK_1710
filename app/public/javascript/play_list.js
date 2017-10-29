$(window).on('load', function () {
    $('button.play').on('click', function () {
        var artist = $(this).parent().parent().find('div.artist').text();
        var track_title = $(this).parent().parent().find('div.track_title').text();
        var term = artist + ' ' + track_title;
        console.log(term);
        var params = {
            term: term,
            limit: 1,
            lang: 'ja_jp',
            entry: 'music',
            media: 'music',
            country: 'JP'
        };
        console.log(params);
        $.ajax({
            url: 'https://itunes.apple.com/search',
            method: 'GET',
            data: params,
            dataType: 'jsonp',
            success: function (json) {
                console.log(json);
                playData(json);
            },
            error: function () {
                console.log('api search error');
            },
        });

        var playData = function (json) {
            var result = json.results[0].previewUrl;
            console.log(result);
            var html = '<audio id="sound" src="' + result + '" autoplay controls />';
            $('#itunes-preview').html(html);
        }
    });
});

