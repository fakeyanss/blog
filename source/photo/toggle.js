function setActive(tagName) {
    if (tagName == 'photo') {
      document.getElementById("photoA").className = "photos-btn active";
      document.getElementById("gameA").className = "photos-btn";
      document.getElementById("photoD").style.display="block";
      document.getElementById("gameD").style.display="none";
    } else {
      document.getElementById("photoA").className = "photos-btn";
      document.getElementById("gameA").className = "photos-btn active";
      document.getElementById("photoD").style.display="none";
      document.getElementById("gameD").style.display="block";
    }
}