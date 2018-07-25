function setActive(tagName) {
    if (tagName == 'words') {
      document.getElementById("wordsA").className = "photos-btn active";
      document.getElementById("resumeA").className = "photos-btn";
      document.getElementById("wordsD").style.display="block";
      document.getElementById("resumeD").style.display="none";
    } else {
      document.getElementById("wordsA").className = "photos-btn";
      document.getElementById("resumeA").className = "photos-btn active";
      document.getElementById("wordsD").style.display="none";
      document.getElementById("resumeD").style.display="block";
    }
}