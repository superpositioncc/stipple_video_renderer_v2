class Dot {
	float x, y, radius, intensity, scaling, tScaling;
	PImage image;

	Dot(float x, float y, PImage image) {
		this.x = x;
		this.y = y;
		this.radius = minSize;
		this.scaling = 1;
		this.image = image;
	}

	void setScaling(float scaling) {
		this.tScaling = scaling;
	}

	void update(Dots parent) {
		this.scaling = lerp(scaling, tScaling, .2);

		color pixel = parent.map.get((int) this.x, (int) this.y);
		this.intensity = brightness(pixel) / 255;

		this.intensity = 1f - this.intensity;

		float dx = 0;
		float dy = 0;

		for (Dot dot: parent.dots) {
			if (dot == this) continue;

			float distance = dist(this.x, this.y, dot.x, dot.y);

			if (distance < maxInfluence) {
				float direction = atan2(this.y - dot.y, this.x - dot.x);
				float influence = 1f - distance / maxInfluence;

				dx += cos(direction) * influence * (dot.intensity * speed + .5);
				dy += sin(direction) * influence * (dot.intensity * speed + .5);
			}
		}

		if (this.y > height - this.radius / 2 && dy > 0) dy = 0;
		else if (this.y < this.radius / 2 && dy < 0) dy = 0;

		if (this.x > width - this.radius / 2 && dx > 0) dx = 0;
		else if (this.x < this.radius / 2 && dx < 0) dx = 0;

		this.x += dx;
		this.y += dy;

		this.radius = (1f - this.intensity) * (maxSize - minSize) + minSize;
	}

	void display(PGraphics ctx) {
		ctx.imageMode(CENTER);
		ctx.pushMatrix();
		ctx.translate(this.x, this.y);

		float aspect = (float) this.image.width / this.image.height;
		float w = this.radius * this.scaling;
		float h = this.radius * this.scaling / aspect;

		ctx.image(this.image, 0, 0, w, h);
		ctx.popMatrix();
	}
}
