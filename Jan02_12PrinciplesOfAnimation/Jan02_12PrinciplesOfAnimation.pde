PImage[] horseFrames = new PImage[15];
int currentFrame = 0;
int smearing = 15;

void setup() {
	size(600, 400);

	stroke(0, 0, 0);
	strokeWeight(1);
	noFill();
	for (int i = 0; i < horseFrames.length; i++) {
		PImage horse = loadImage("frames/horse-" + (i + 1) + ".jpg");
		horse.resize(width, height);
		horseFrames[i] = horse;
	}
}

void draw() {
	background(100);

	int nextFrame = (currentFrame + 1) % (horseFrames.length - 1);

	PImage blendFrame = horseFrames[currentFrame].copy();
	for (int i = 1; i < smearing; i++) {
		blendFrame.blend(horseFrames[(nextFrame + smearing) % (horseFrames.length - 1)],
			0, 0,
			width, height,
			0, 0,
			width, height,
			DIFFERENCE
		);
	}

	image(blendFrame, 0, 0);

	currentFrame = nextFrame;
}