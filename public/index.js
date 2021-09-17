window.addEventListener("load", function(){
  var userHostname = "localhost";
  var userPort = "7144";
  function populateTable(text){
    var lines = text.split(/\n/);
    lines.length -= 1;

    var buf = "";
    buf += `<p>${lines.length} チャンネル</p>`;
    for (var line of lines) {
      var fields = line.split(/<>/);
      let [name, id, ip, url, genre, description,
           listeners, relays, bitrate, type,
           track_artist, track_album,
           track_title, track_contact,
           name_url_encoded, time,
           status, comment, direct] = fields;

      buf += `<a href="http://${userHostname}:${userPort}/pls/${id}">${name}</a> `;
      if (direct == "1") {
        buf += `<a title="リレーせずにトラッカーから直接視聴する。" href="http://${ip}/pls/${id}">直リンク</a> `;
      }
      buf += `${description} `;
      if (url) {
        buf += `[<a href="${url}">掲示板</a>]<br>`;
      } else {
        buf += `[掲示板]<br>`;
      }
    }
    document.getElementById("channels").innerHTML = buf;
  }
  function loadDoc() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        populateTable(this.responseText);
      }
    };
    xhttp.open("GET", "index.txt?", true);
    xhttp.send();
  }
  function loadUserSettings(){
    userHostname = localStorage["userHostname"] || userHostname;
    userPort = localStorage["userPort"] || userPort;
  }
  function renderUserSettings(){
    document.getElementById("user-hostname").value = userHostname;
    document.getElementById("user-port").value = userPort;
  }
  function saveUserSettings(){
    localStorage["userHostname"] = document.getElementById("user-hostname").value;
    localStorage["userPort"] = document.getElementById("user-port").value;
  }
  var saveButton = document.getElementById("save-button");
  saveButton.addEventListener("click", function(){
    saveUserSettings();
    location.reload();
  });
  loadUserSettings();
  renderUserSettings();
  loadDoc();
});
