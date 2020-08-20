class Spring2D {
  float vx, vy; // The x- and y-axis velocities
  float x, y; // The x- and y-coordinates
  float gravity;
  float mass;
  float radius = 30;
  float stiffness = 0.2;
  float damping = 0.7;
  
  Spring2D(float xpos, float ypos, float m, float g) {
    x = xpos;
    y = ypos;
    mass = m;
    gravity = g;
  }
  
  void update(float targetX, float targetY) {
    float forceX = (targetX - x) * stiffness;
    float ax = forceX / mass;
    vx = damping * (vx + ax);
    x += vx;
    float forceY = (targetY - y) * stiffness;
    forceY += gravity;
    float ay = forceY / mass;
    vy = damping * (vy + ay);
    y += vy;
  }
  
  void display(float nx, float ny) {
    noStroke();
    fill(0);
    ellipse(x, y, radius*2, radius*2);
    stroke(100);
    line(x, y, nx, ny);
  }
}
