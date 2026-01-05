PImage inputImage;

int pointCount;
ArrayList<PVector> points = new ArrayList<>();

void setup() {
	size(240, 284);

	ellipseMode(CENTER);

	inputImage = loadImage("data/1665_Girl_with_a_Pearl_Earring.jpg");

	background(0);

	pointCount = int(sqrt(inputImage.width * inputImage.height));
	for (int i = 0; i < pointCount; i++) {
		points.add(new PVector(random(1), random(1)));
	}

	blendMode(LIGHTEST);
	noStroke();
	for (PVector point : points) {
		PVector imageSamplePoint = new PVector(point.x * inputImage.width, point.y * inputImage.height);
		PVector rectPoint = new PVector(point.x * width, point.y * height);
		int sampleColor = inputImage.get((int)imageSamplePoint.x, (int)imageSamplePoint.y);
		if (brightness(sampleColor) > 20) {
			fill(sampleColor);
			ellipse(rectPoint.x, rectPoint.y, map(saturation(sampleColor), 0, 255, 10, 40), map(saturation(sampleColor), 0, 255, 10, 40));
		}
	}
}
