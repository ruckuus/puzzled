var http = require('follow-redirects').http;

var options = {
    hostname: 'www.stomp.com.sg',
    port: 80,
    method: 'GET'
};

var req = http.request(options, function(res) {
    console.log('STATUS: ' + res.statusCode);
    console.log('HEADERS' + JSON.stringify(res.headers));
});

req.on('error', function(e) {
    console.log('problem: ' + e.message);
});

req.write('data\n');
req.end();
