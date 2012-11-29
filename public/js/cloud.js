function switchLang(lang){
    $.get('/cloud/' + lang, function(data){
        installTableHistogram(data);
        installCloud(data);
    });
    return false;
}

function installTableHistogram(histogram){
    var template = '\
    <table class="table table-striped table-bordered">\
      <tr>\
        <th>word</th>\
        <th>frequency</th>\
      </tr>\
      {{#histogram}}\
        <tr>\
          <td>{{word}}</td>\
          <td>{{frequency}}</td>\
        </tr>\
      {{/histogram}}\
    </table>';
    var output = Mustache.render(template, {'histogram': histogram});
    $("#histogram").html(output);
}

function installCloud(histogram){
    var fill = d3.scale.category20();
    d3.layout.cloud().size([600, 600])
        .words(histogram)
        .rotate(function() { return ~~(Math.random() * 2) * 90; })
        .text(function(d){ return d.word; })
        .font("Impact")
        .fontSize(function(d) { return Math.min(12+3*d.frequency*d.frequency, 100); })
        .on("end", draw)
        .start();
    function draw(words) {
      $("#cloud").html("");
      d3.select("#cloud").append("svg")
          .attr("width", 600)
          .attr("height", 600)
        .append("g")
          .attr("transform", "translate(300,300)")
        .selectAll("text")
          .data(words)
        .enter().append("text")
          .style("font-size", function(d) { return d.size + "px"; })
          .style("font-family", "Impact")
          .style("fill", function(d, i) { return fill(i); })
          .attr("text-anchor", "middle")
          .attr("transform", function(d) {
            return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
          })
          .text(function(d) { return d.text; });
    }
}
