let font
let whiteGlyph
let blackGlyph
let transitionTick = -Math.PI / 2
const transitionStep = 0.01
const offsetCount = 32

function preload() {
    font = loadFont('font/NotoSansSC-Medium.ttf')
}

function setup() {
    createCanvas(1080, 1080)
    rectMode(CENTER)
    textFont(font)
    textSize(140)

    whiteGlyph = font.textToPoints(
        '白',
        0, 0,
        720,
        {
            sampleFactor: 0.1,
            simplifyThreshold: 0,
        }
    )
    let blackGlyphSampleFactor = 0.1
    do {
        blackGlyph = font.textToPoints(
            '黑',
            0, 0,
            720,
            {
                sampleFactor: blackGlyphSampleFactor,
                simplifyThreshold: 0,
            }
        )
        blackGlyphSampleFactor -= 0.001
    } while (blackGlyph.length !== whiteGlyph.length)

}

function draw() {
    background(lerpColor(color(255), color(0), norm(sin(transitionTick), -1, 1)))
    translate(160, height * 0.74)

    for (let d = 1; d < offsetCount; d++) {
        drawShape(whiteGlyph, blackGlyph, transitionTick, d)
    }

    transitionTick += transitionStep
}

function drawShape(pathA, pathB, a, offset = 1) {
    a = norm(sin(a), -1, 1)
    noFill()

    const t = map(offset, 1, offsetCount, 255, 10)
    const s = lerpColor(
        offset % 2 === 0 ? color(255, 255, 255, t) : color(0, 0, 0, t),
        offset % 2 === 0 ? color(0, 0, 0, t) : color(255, 255, 255, t),
        norm(sin(transitionTick), -1, 1)
    )
    stroke(s)
    beginShape()
    strokeWeight(2)
    for (let i = 0; i < pathA.length - 1; i++) {
        const pointA = getSmoothVector(pathA, i, offset * 2)
        const pointB = getSmoothVector(pathB, i, offset * 2)
        const lerpedVector = p5.Vector.slerp(pointA, pointB, a)
        curveVertex(lerpedVector.x, lerpedVector.y)
    }
    endShape()
}

function getSmoothVector(path, index, offset = 1) {
    const pos = path[index]
    const nextPos = path[index + 1]
    const p0 = createVector(pos.x, pos.y)
    const p1 = createVector(nextPos.x, nextPos.y)
    p1.sub(p0)
    p1.normalize()
    p1.rotate(HALF_PI)
    p1.mult(offset)
    p0.add(p1)
    return p0
}
