int tileCount = 5;
PGraphics img;
PVector pos;
PVector previousPos;

void setup() {
	size(1080, 1080);
	noFill();

	pos = getPosition();
	previousPos = getPosition();

	img = createGraphics(width, height);
}

void draw() {
	background(0);
	img.beginDraw();
	img.colorMode(HSB, 1000, 100, 100);

	int w = width / tileCount;
	int h = height / tileCount;
	pos = getPosition();
	int x = int(pos.x % w);
	int y = int(pos.y % h);
	int px = int(x - (pos.x - previousPos.x));
	int py = int(y - (pos.y - previousPos.y));

	img.strokeWeight(sqrt(min(10, previousPos.dist(pos))));
	img.stroke(
		frameCount % 1000,
		60,
		map(noise(frameCount), 0, 1, 100, 70)
	);

	for (int tileX = 0; tileX < tileCount; tileX++) {
		for (int tileY = 0; tileY < tileCount; tileY++) {
			int ox = tileX * w;
			int oy = tileY * h;

			img.line(x + ox, y + oy, px + ox, py + oy);
			img.line(w - x + ox, y + oy, w - px + ox, py + oy);
			img.line(x + ox, h - y + oy, px + ox, h - py + oy);
			img.line(w - x + ox, h - y + oy, w - px + ox, h - py + oy);

			img.line(y + ox, x + oy, py + ox, px + oy);
			img.line(y + ox, w - x + oy, py + ox, w - px + oy);
			img.line(h - y + ox, x + oy, h - py + ox, px + oy);
			img.line(h - y + ox, w - x + oy, h - py + ox, w - px + oy);
		}
	}
	img.endDraw();

	image(img, 0, 0);

	previousPos = pos.copy();
}

PVector getPosition() {
	return new PVector(
		width / 2 + (cos(frameCount * 0.007) + noise(frameCount * 0.01)) * width / 2,
		height / 2 + (sin(frameCount * 0.007) + noise(frameCount * 0.01)) * height / 2
	);
}