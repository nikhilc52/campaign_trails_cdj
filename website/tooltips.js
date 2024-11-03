function myFunction(e, tooltipID, elementID) {
    var x = e.clientX; //x is the distance from the left of the screen
    var y = e.clientY; //y is the distance from the top of the screen
    
    //places the tool tip at the pixel location along the canvas
    //since window.scrollX says how far along we are on the page. offset by the position of the element we're hovering over (offsetLeft)
    document.getElementById(tooltipID).style.left = x+window.scrollX-document.getElementById(elementID).offsetLeft+20 + "px"; 
    
    //places the tool tip at the pixel location along the canvas (relative to the top of the page)
    // offset by the position of the element we're hovering over (offsetTop)
    document.getElementById(tooltipID).style.top = y-document.getElementById(elementID).offsetTop-50 + "px";
}