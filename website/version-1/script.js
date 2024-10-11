function updateFrame(src, slider, img) {
    var frameID = document.getElementById(slider).value;
    var imageName = src + "/" + frameID + ".png";
    document.getElementById(img).src = imageName;
}