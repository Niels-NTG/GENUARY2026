const elementTypes = new Set()
let colorPallette = new Map()
let treeMap
const mapWidth = 2000
const mapHeight = 2000

let isRecording = false
let recordingStartTime = 0
const rotationRate = 0.01

document.querySelector('iframe').addEventListener('load', () => {
	const frame = document.querySelector('iframe').contentDocument
	const tree = traverseTree(frame.body)
	treeMap = d3.treemap().tile(d3.treemapResquarify).size([mapWidth, mapHeight]).padding(4).round(true)(
		d3.hierarchy(tree).sum(d => d.value).sort((a, b) => b.value - a.value)
	)
})

function traverseTree(parentNode) {
	const o = {
		name: parentNode.nodeName,
	}
	elementTypes.add(parentNode.nodeName)
	if (parentNode.nodeType === Node.TEXT_NODE) {
		o.value = Math.min(1000, Math.sqrt(parentNode.wholeText.length) * 10)
	}
	if (!parentNode.hasChildNodes()) {
		return o
	}
	o.children = []
	for (const childNode of parentNode.childNodes) {
		o.children.push(traverseTree(childNode))
	}
	return o
}

function loadFrame() {
	return new Promise((resolve) => {
		setTimeout(() => {
			resolve()
		}, 1000)
	})
}

async function setup() {
	createCanvas(3080, 3080, WEBGL)
	colorMode(HSB, 360, 100, 100)
	randomSeed(999988222144470)

	// Yes, I know there better ways of waiting for DOM content to load. Don't @ me.
	await loadFrame()

	elementTypes.values().forEach((type, index) => {
		colorPallette.set(
			type,
			color(
				random(0, 360),
				random(60, 100),
				100
			)
		)
	})

	ortho(-width / 2, width / 2, height / 2, -height / 2, -max(mapWidth, mapHeight) * 2, max(mapWidth, mapHeight) * 2)
}

function draw() {
	background(0)
	lights()
	orbitControl()

	rotateY(frameCount * rotationRate)
	rotateZ(PI)
	translate(-mapWidth / 2, 0, -mapHeight / 2)
	drawRect(treeMap, 0)

	if (isRecording) {
		if (frameCount * rotationRate > recordingStartTime + TAU) {
			isRecording = false
			noLoop()
			return
		}
		saveCanvas(`city-${Date.now()}.png`, 'png')
	}
}

function keyPressed() {
	if (key === 's') {
		isRecording = !isRecording
		recordingStartTime = frameCount * rotationRate
	}
}

function drawRect(node, depth) {
	const previousDepth = depth
	if (node.data.name.startsWith('#')) {
		depth += node.data.value
	} else {
		depth++
	}

	push()
	fill(colorPallette.get(node.data.name))
	stroke(colorPallette.get(node.data.name))

	const nodeWidth = node.x1 - node.x0
	const nodeHeight = node.y1 - node.y0
	translate(node.x0 + nodeWidth / 2, -((depth / 2) + (previousDepth * 2)), node.y0 + nodeHeight / 2)
	box(
		nodeWidth,
		depth,
		nodeHeight
	)
	pop()

	if (node.children) {
		for (const childNode of node.children) {
			drawRect(childNode, depth)
		}
	}
}
