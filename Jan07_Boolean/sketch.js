// Note: this sketch needs the library Kokopu v4.
// Download it from https://kokopu.yo35.org/ and
// place kokopu.js in the lib folder.

const squareSize = 1080 / 8
const captureDotSize = squareSize / 3.4

let gamesDatabase
let games = []
let currentGame
let currentGameMove
let currentGameTotalMoves

async function setup() {
	createCanvas(1080, 1080)
	ellipseMode(CENTER)
	strokeJoin(ROUND)
	randomSeed(700)

	// Requires a PGN file (https://en.wikipedia.org/wiki/Portable_Game_Notation)
	const gameFile = (await loadStrings('data/games2.pgn')).join('\n')

	drawChessBoard()

	gamesDatabase = kokopu.pgnRead(gameFile)
	console.log(gamesDatabase.gameCount())

	games = Array.from(gamesDatabase.games())
	setCurrentGame()
}

function draw() {
	clear()
	drawChessBoard()

	drawGame(currentGame, currentGameMove)

	currentGameMove++
	if (currentGameMove > currentGameTotalMoves) {
		setCurrentGame()
	}
}

function drawChessBoard() {
	noStroke()
	kokopu.forEachSquare((boardSquare) => {
		const x = kokopu.squareToCoordinates(boardSquare).file * squareSize
		const y = kokopu.squareToCoordinates(boardSquare).rank * squareSize
		const isWhiteSquare = kokopu.squareColor(boardSquare) === 'w'

		fill(isWhiteSquare ? 255 : 0)
		rect(x, y, squareSize, squareSize)
	})
}

function setCurrentGame() {
	if (games.length) {
		currentGame = games.shift()
		currentGameMove = 0
		currentGameTotalMoves = ceil(currentGame.plyCount() / 2)
	} else {
		games = Array.from(gamesDatabase.games())
		setCurrentGame()
	}
}

function drawGame(game, untilMove) {
	const whitePlayerMoves = []
	const blackPlayerMoves = []
	for (const node of game.mainVariation().nodes()) {
		if (node.fullMoveNumber() > untilMove + 1) {
			break
		}
		const moveColor = node.moveColor()
		if (moveColor === 'w') {
			whitePlayerMoves.push(node.positionBefore().notation(node.notation()))
		} else if (moveColor === 'b') {
			blackPlayerMoves.push(node.positionBefore().notation(node.notation()))
		}
	}

	blendMode(DIFFERENCE)
	drawPlayerMoves(whitePlayerMoves, true)
	drawPlayerMoves(blackPlayerMoves)
}

function drawPlayerMoves(moves, drawCaptures) {
	noFill()
	stroke(255)
	strokeWeight(10)
	beginShape()
	for (const move of moves) {
		const p = getChessPositionVertex(move.to())
		splineVertex(p.x, p.y)
		if (drawCaptures && move.isCapture()) {
			noStroke()
			fill(255)
			ellipse(
				p.x + random(-captureDotSize, captureDotSize),
				p.y + random(-captureDotSize, captureDotSize),
				captureDotSize,
				captureDotSize
			)
			noFill()
			stroke(255)
		}
	}
	endShape()
}

function getChessPositionVertex(chessMove) {
	return createVector(
		(kokopu.squareToCoordinates(chessMove).file * squareSize) + (squareSize / 2),
		(kokopu.squareToCoordinates(chessMove).rank * squareSize) + (squareSize / 2)
	)
}