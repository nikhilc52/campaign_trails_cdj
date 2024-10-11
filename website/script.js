var svg
var path

const scroll = () => {
    if(window.scrollX > 2000){
        svg = document.querySelector("svg.numbers-line")
        animate(svg, 3000, 0.5)
    }
    if(window.scrollX <= 3000){
        svg = document.querySelector("svg.america-line")
        animate(svg, 0, 0.5)
    }
}

const animate = (svg, offset, speed) => {
    path = svg.querySelector("path")

    const pathLength = path.getTotalLength()
    const distance = window.scrollX-offset
    const totalDistance = window.innerWidth

    const percentage = distance / totalDistance

    path.style.strokeDasharray = `${pathLength}`
    path.style.strokeDashoffset = `${pathLength * (1-percentage*speed)}`

    console.log(window.scrollX)
}

scroll()
window.addEventListener("scroll",scroll)