final double squareRootOf5 = Math.sqrt(5);
final double phi = (1 + squareRootOf5) / 2;
final int recursionDepth = 41;
int[] sequence = new int[recursionDepth];
int maxValue;

void setup() {
	size(1080, 1080, P3D);

	for (int i = 0; i < recursionDepth; i++) {
		sequence[i] = nthFibonacciTerm(i);
	}
	maxValue = sequence[sequence.length - 1];
	println(sequence);

	colorMode(HSB, 360, 100, 100);
	rectMode(CENTER);
	stroke(0, 0, 0);
	strokeWeight(1);
	noFill();

	ortho(-width / 2 , width / 2, -height / 2, height / 2, -width * 100, width * 100);
}

void draw() {
	background(0, 100, 100);
	translate(width / 2, height / 2);
	for (int i = 0; i < sequence.length; i++) {
		strokeWeight(1 + norm(sequence[i], 0, maxValue) * 400);
		stroke(map(i, 0, sequence.length, 0, 360), 100, 100);
		box(norm(sequence[i], 0, maxValue) * width * 10);
		rotateX(map(i, 0, sequence.length, 0, PI) * (frameCount / PI / 1000));
		rotateY(map(i, 0, sequence.length, 0, PI) * (frameCount / PI / 1200));
		rotateY(map(i, 0, sequence.length, 0, PI) * (frameCount / PI / 900));
	}
}

// Binet's Formula: https://en.wikipedia.org/wiki/Fibonacci_sequence#Binet's_formula
int nthFibonacciTerm(int n) {
	int nthTerm = (int) ((Math.pow(phi, n) - Math.pow(-phi, -n)) / squareRootOf5);
	return nthTerm;
}
