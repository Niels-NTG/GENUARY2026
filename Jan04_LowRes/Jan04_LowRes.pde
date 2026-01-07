void setup() {
	size(240, 284);

	ellipseMode(CENTER);

	PImage inputImage = loadImage("data/1665_Girl_with_a_Pearl_Earring.jpg");

	background(0);

	final int pointCount = int(sqrt(inputImage.width * inputImage.height));

	blendMode(LIGHTEST);
	noStroke();
	for (int i = 0; i < pointCount; i++) {
		PVector point = new PVector(random(1), random(1));
		PVector imageSamplePoint = new PVector(point.x * inputImage.width, point.y * inputImage.height);
		PVector rectPoint = new PVector(point.x * width, point.y * height);
		int sampleColor = inputImage.get((int)imageSamplePoint.x, (int)imageSamplePoint.y);
		if (brightness(sampleColor) > 20) {
			fill(sampleColor);
			ellipse(rectPoint.x, rectPoint.y, map(saturation(sampleColor), 0, 255, 10, 40), map(saturation(sampleColor), 0, 255, 10, 40));
		}
	}
}
