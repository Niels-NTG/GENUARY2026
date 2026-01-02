PFont font;
final int initialFontsize = 2000;
int fontSize = initialFontsize;
float spinRate = 0.01;

void setup() {
	size(1080, 1080);
	colorMode(HSB, 360, fontSize, 100);
	printArray(PFont.list());
	font = createFont("Recursive Sn Lnr St XBd", initialFontsize);
	textFont(font);
	textAlign(CENTER, CENTER);
	textSize(fontSize);
	background(200, initialFontsize, 20);
}

void draw() {
	background(200, initialFontsize, 20);
	translate(width / 2, height / 2);

	int rotationOffset = 0;
	while (fontSize > 64) {
		rotate((frameCount - rotationOffset) / PI * spinRate);
		fill(200, fontSize, 100);
		textSize(fontSize);
		text("Y", 0, -fontSize / 4);
		fontSize -= 64;
		rotationOffset++;
	}
	fontSize = initialFontsize;
}
