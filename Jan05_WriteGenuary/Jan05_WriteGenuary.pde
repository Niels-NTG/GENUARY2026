ArrayList<PVector[]> glyphs = new ArrayList<>();
int animationFrame = 0;
final int animationStopFrame = 2000;

void setup() {
	size(1200, 400);

	// G
	glyphs.add(new PVector[]{
        new PVector(2, 2),
        new PVector(3, 2),
        new PVector(3, 3),
        new PVector(2, 4),
        new PVector(1, 3),
        new PVector(1, 1),
        new PVector(2, 0),
        new PVector(3, 1)
    });
	// E
	glyphs.add(new PVector[]{
		new PVector(5, 2),
		new PVector(6, 2)
	});
	glyphs.add(new PVector[]{
		new PVector(6, 0),
		new PVector(4, 1),
		new PVector(4, 3),
		new PVector(6, 4)
	});
	// N
	glyphs.add(new PVector[]{
		new PVector(7, 4),
		new PVector(7, 0),
		new PVector(10, 4),
		new PVector(10, 0)
	});
	// U
	glyphs.add(new PVector[]{
		new PVector(11, 0),
		new PVector(11, 3),
		new PVector(13, 4),
		new PVector(15, 3),
		new PVector(15, 0)
	});
	// A
	glyphs.add(new PVector[]{
		new PVector(17, 2),
		new PVector(19, 2)
	});
	glyphs.add(new PVector[]{
		new PVector(16, 4),
		new PVector(16, 2),
		new PVector(18, 0),
		new PVector(20, 2),
		new PVector(20, 4)
	});
	// R
	glyphs.add(new PVector[]{
		new PVector(21, 4),
		new PVector(21, 0),
		new PVector(22, 0),
		new PVector(23, 1),
		new PVector(22, 2),
		new PVector(23, 4)
	});
	// Y
	glyphs.add(new PVector[]{
		new PVector(24, 0),
		new PVector(25, 2)
	});
	glyphs.add(new PVector[]{
		new PVector(26, 0),
		new PVector(24, 4)
	});

	noFill();
	stroke(255);
	strokeJoin(ROUND);
}

void draw() {
	background(0);
	strokeWeight(map(animationFrame, 0, animationStopFrame, 10, 2));
	for (PVector[] points : glyphs) {
		beginShape();
		for (int i = 0; i < points.length; i++) {
			PVector point = points[i];
			PVector nextPoint = points[0];
			try {
				nextPoint = points[i + 1];
			} catch (ArrayIndexOutOfBoundsException ignored) {}

			if (nextPoint == null) {
				nextPoint = points[0];
			}
			PVector rotatedPoint = point.copy().normalize().rotate(
				map(animationFrame, 0, animationStopFrame, 0, PI)
			).add(point).lerp(nextPoint, map(animationFrame, 0, animationStopFrame, 0, 1));

			vertex(
				map(rotatedPoint.x, 0, 26, 100, width - 100),
				map(rotatedPoint.y, 0, 4, 100, height - 100)
			);
		}
		endShape();
	}

	animationFrame++;
	if (animationFrame > animationStopFrame) {
		exit();
	}
}
