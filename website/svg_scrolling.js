var svg
var path

const scroll = () => {
    if (window.scrollX <= 3000) {
        svg = document.querySelector("svg.america-line")
        animate(svg, 0, 1.5)
    }
    if (window.scrollX > 2000) {
        svg = document.querySelector("svg.numbers-line")
        animate(svg, 3000, 1.5)
    }
    if (window.scrollX > 7000) {
        svg = document.querySelector("svg.bush-obama-line")
        animate(svg, 9500, 1)
    }
}

//offset is the (about) starting position of the path (distance in px of the path from the left)
//decrease offset to start animation earlier
const animate = (svg, offset, speed) => {
    path = svg.querySelector("path")

    //path length is the length of the svg
    const pathLength = path.getTotalLength()
    //distance is meant to be the current position along the path - 
    //starting as if the path were 0 (so offset is just the path position)
    const distance = window.scrollX - offset

    //percentage is how far along we are on the screen
    const percentage = distance / pathLength

    //this just makes the path into an array of path length 'chunks', which are offset to give the illusion of movement
    path.style.strokeDasharray = `${pathLength}`
    //this offsets the path by a decreasing amount as the scroll goes on, so the path gets 'appended' as we scroll
    //using max on the percentage so we only show nothing until the percentage is within 0 to 1
    //using max on the whole value so that after the animation is finished - percentage is > 1, but we just want to show the full path, so offset is 0
    path.style.strokeDashoffset = `${Math.max(pathLength * (1 - Math.max(percentage,0) * speed),0)}`

    // console.log(percentage)
    // console.log(window.scrollX)
    // console.log(pathLength)
}

scroll()
window.addEventListener("scroll", scroll)